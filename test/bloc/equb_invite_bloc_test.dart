import 'package:bloc_test/bloc_test.dart';
import 'package:equb_v3_frontend/blocs/equb_invite/equb_invite_bloc.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/builders/equb_builder.dart';
import '../support/builders/equb_invite_builder.dart';
import '../support/builders/user_builder.dart';
import '../support/fakes/fake_equb_invite_repository.dart';
import '../support/fakes/fake_friendship_repository.dart';
import '../support/fakes/fake_user_repository.dart';

void main() {
  late FakeEqubInviteRepository inviteRepository;
  late FakeUserRepository userRepository;
  late FakeFriendshipRepository friendshipRepository;

  final alice = buildUser(id: 1, firstName: 'Alice');
  final bob = buildUser(id: 2, firstName: 'Bob');
  final carol = buildUser(id: 3, firstName: 'Carol');

  setUp(() {
    inviteRepository = FakeEqubInviteRepository();
    userRepository = FakeUserRepository();
    friendshipRepository = FakeFriendshipRepository();
  });

  EqubInviteBloc build() => EqubInviteBloc(
        equbInviteRepository: inviteRepository,
        userRepository: userRepository,
        friendshipRepository: friendshipRepository,
      );

  group('invites to an equb', () {
    blocTest<EqubInviteBloc, EqubInviteState>(
      'recommends friends who are neither members nor already invited',
      build: build,
      act: (bloc) {
        final equb = buildEqubDetail(id: 7, members: [alice]);
        friendshipRepository.friendsResult = [alice, bob, carol];
        inviteRepository.invitesToEqubResult = [buildEqubInvite(receiver: bob)];
        bloc.add(FetchEqubInvitesToEqub(equb));
      },
      verify: (bloc) {
        final statuses = {
          for (final u in bloc.state.recommendedUsers) u.user.id: u.inviteStatus
        };
        expect(statuses[alice.id], InviteStatus.member);
        expect(statuses[bob.id], InviteStatus.invited);
        expect(statuses[carol.id], InviteStatus.none);
      },
    );
  });

  group('create invite', () {
    blocTest<EqubInviteBloc, EqubInviteState>(
      'flips the invited user in both the search and recommendation lists',
      build: build,
      seed: () => EqubInviteState(
        status: EqubInviteStatus.success,
        searchedUsers: [
          UserWithInviteStatus(user: carol, inviteStatus: InviteStatus.none),
        ],
        recommendedUsers: [
          UserWithInviteStatus(user: carol, inviteStatus: InviteStatus.none),
        ],
      ),
      act: (bloc) =>
          bloc.add(CreateEqubInvite(carol.id, buildEqubDetail(id: 7))),
      verify: (bloc) {
        expect(bloc.state.searchedUsers.single.inviteStatus,
            InviteStatus.invited);
        expect(bloc.state.recommendedUsers.single.inviteStatus,
            InviteStatus.invited);
        expect(inviteRepository.calls, contains('createEqubInvite(3, 7)'));
      },
    );
  });

  group('accept and expire', () {
    blocTest<EqubInviteBloc, EqubInviteState>(
      'drops an accepted invite from the list',
      build: build,
      seed: () => EqubInviteState(
        status: EqubInviteStatus.success,
        equbInvites: [buildEqubInvite(id: 1), buildEqubInvite(id: 2)],
      ),
      act: (bloc) => bloc.add(const AcceptEqubInvite(1)),
      verify: (bloc) =>
          expect(bloc.state.equbInvites.map((i) => i.id), [2]),
    );

    blocTest<EqubInviteBloc, EqubInviteState>(
      'drops an expired invite from the list',
      build: build,
      seed: () => EqubInviteState(
        status: EqubInviteStatus.success,
        equbInvites: [buildEqubInvite(id: 1), buildEqubInvite(id: 2)],
      ),
      act: (bloc) => bloc.add(const ExpireEqubInvite(2)),
      verify: (bloc) =>
          expect(bloc.state.equbInvites.map((i) => i.id), [1]),
    );
  });

  group('search', () {
    blocTest<EqubInviteBloc, EqubInviteState>(
      'classifies searched users against the current equb members',
      build: build,
      seed: () => EqubInviteState(
        status: EqubInviteStatus.success,
        equb: buildEqubDetail(id: 7, members: [alice]),
        equbInvites: [buildEqubInvite(receiver: bob)],
      ),
      act: (bloc) {
        userRepository.searchResult = [alice, bob, carol];
        bloc.add(const FetchUsersByName('a'));
      },
      verify: (bloc) {
        final statuses = {
          for (final u in bloc.state.searchedUsers) u.user.id: u.inviteStatus
        };
        expect(statuses[alice.id], InviteStatus.member);
        expect(statuses[bob.id], InviteStatus.invited);
        expect(statuses[carol.id], InviteStatus.none);
      },
    );

    blocTest<EqubInviteBloc, EqubInviteState>(
      'treats everyone as uninvited when no equb is selected',
      build: build,
      act: (bloc) {
        userRepository.searchResult = [alice, bob];
        bloc.add(const FetchUsersByName('a'));
      },
      verify: (bloc) => expect(
        bloc.state.searchedUsers.map((u) => u.inviteStatus),
        everyElement(InviteStatus.none),
      ),
    );
  });
}
