import 'package:bloc_test/bloc_test.dart';
import 'package:equb_v3_frontend/blocs/friendships/friendships_bloc.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/builders/friendship_builder.dart';
import '../support/builders/user_builder.dart';
import '../support/fakes/fake_friendship_repository.dart';
import '../support/fakes/fake_user_repository.dart';

void main() {
  late FakeFriendshipRepository friendshipRepository;
  late FakeUserRepository userRepository;

  final alice = buildUser(id: 1, firstName: 'Alice');
  final bob = buildUser(id: 2, firstName: 'Bob');
  final carol = buildUser(id: 3, firstName: 'Carol');

  setUp(() {
    friendshipRepository = FakeFriendshipRepository();
    userRepository = FakeUserRepository();
  });

  FriendshipsBloc build() => FriendshipsBloc(
        friendshipRepository: friendshipRepository,
        userRepository: userRepository,
      );

  group('fetch friends', () {
    blocTest<FriendshipsBloc, FriendshipsState>(
      'succeeds with the friend list',
      build: build,
      act: (bloc) {
        friendshipRepository.friendsResult = [bob, carol];
        bloc.add(const FetchFriends());
      },
      expect: () => [
        isA<FriendshipsState>()
            .having((s) => s.status, 'status', FriendshipsStatus.loading),
        isA<FriendshipsState>()
            .having((s) => s.status, 'status', FriendshipsStatus.success)
            .having((s) => s.friends, 'friends', [bob, carol]),
      ],
    );
  });

  group('search', () {
    blocTest<FriendshipsBloc, FriendshipsState>(
      'annotates each result with its trust status',
      build: build,
      seed: () => FriendshipsState(
        status: FriendshipsStatus.success,
        friends: [bob],
        sentFriendRequests: [buildFriendRequest(sender: alice, receiver: carol)],
      ),
      act: (bloc) {
        userRepository.searchResult = [bob, carol];
        bloc.add(const FetchUsersByName('a'));
      },
      verify: (bloc) {
        final statuses = {
          for (final u in bloc.state.searchedUsers) u.user.id: u.trustStatus
        };
        expect(statuses[bob.id], TrustStatus.trusted);
        expect(statuses[carol.id], TrustStatus.requestSent);
      },
    );
  });

  group('send friend request', () {
    blocTest<FriendshipsBloc, FriendshipsState>(
      'flips the searched user to requestSent without refetching',
      build: build,
      seed: () => FriendshipsState(
        status: FriendshipsStatus.success,
        searchedUsers: [
          UserWithTrustStatus(user: carol, trustStatus: TrustStatus.none),
        ],
      ),
      act: (bloc) => bloc.add(SendFriendRequest(carol.id)),
      verify: (bloc) {
        expect(bloc.state.searchedUsers.single.trustStatus,
            TrustStatus.requestSent);
        expect(friendshipRepository.calls, contains('sendFriendRequest(3)'));
      },
    );
  });

  group('accept friend request', () {
    blocTest<FriendshipsBloc, FriendshipsState>(
      'removes the accepted request from the received list',
      build: build,
      seed: () => FriendshipsState(
        status: FriendshipsStatus.success,
        receivedFriendRequests: [
          buildFriendRequest(id: 10, sender: carol, receiver: alice),
          buildFriendRequest(id: 11, sender: bob, receiver: alice),
        ],
      ),
      act: (bloc) => bloc.add(const AcceptFriendRequest(10)),
      verify: (bloc) {
        expect(bloc.state.receivedFriendRequests.map((r) => r.id), [11]);
        expect(friendshipRepository.calls, contains('acceptFriendRequest(10)'));
      },
    );
  });

  group('friend requests', () {
    blocTest<FriendshipsBloc, FriendshipsState>(
      'loads sent requests',
      build: build,
      act: (bloc) {
        friendshipRepository.sentRequestsResult = [
          buildFriendRequest(id: 5, sender: alice, receiver: bob)
        ];
        bloc.add(FetchSentFriendRequests());
      },
      verify: (bloc) => expect(bloc.state.sentFriendRequests.length, 1),
    );

    blocTest<FriendshipsBloc, FriendshipsState>(
      'loads received requests',
      build: build,
      act: (bloc) {
        friendshipRepository.receivedRequestsResult = [
          buildFriendRequest(id: 6, sender: bob, receiver: alice)
        ];
        bloc.add(FetchReceivedFriendRequests());
      },
      verify: (bloc) => expect(bloc.state.receivedFriendRequests.length, 1),
    );

    blocTest<FriendshipsBloc, FriendshipsState>(
      'loads another user friends separately from our own',
      build: build,
      seed: () => FriendshipsState(
        status: FriendshipsStatus.success,
        friends: [bob],
      ),
      act: (bloc) {
        friendshipRepository.focusedUserFriendsResult = [carol];
        bloc.add(const FetchFocusedUserFriends(3));
      },
      verify: (bloc) {
        expect(bloc.state.focusedUserFriends, [carol]);
        expect(bloc.state.friends, [bob]);
      },
    );
  });
}
