import 'package:equatable/equatable.dart';
import 'package:equb_v3_frontend/models/friendship/friend_request.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/repositories/friendship_respository.dart';
import 'package:equb_v3_frontend/repositories/user_repository.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'friendships_event.dart';
part 'friendships_state.dart';

class FriendshipsBloc extends Bloc<FriendshipsEvent, FriendshipsState> {
  final FriendshipRepository friendshipRepository;
  final UserRepository userRepository;

  FriendshipsBloc(
      {required this.friendshipRepository, required this.userRepository})
      : super(const FriendshipsState()) {
    on<SendFriendRequest>(_onSendFriendRequest);
    on<AcceptFriendRequest>(_onAcceptFriendRequest);
    on<FetchFriends>(_onFetchFriends);
    on<FetchUsersByName>(_onFetchUsersByName);
    on<FetchSentFriendRequests>(_onFetchSentFriendRequests);
    on<FetchReceivedFriendRequests>(_onFetchReceivedFriendRequests);
  }

  void _onSendFriendRequest(
      SendFriendRequest event, Emitter<FriendshipsState> emit) async {
    emit(state.copyWith(status: FriendshipsStatus.loading));

    final friendRequest =
        await friendshipRepository.sendFriendRequest(event.receiverId);
    emit(
      FriendshipsState(
        friends: state.friends,
        status: FriendshipsStatus.success,
        sentFriendRequests: [
          friendRequest,
          ...state.sentFriendRequests,
        ],
        searchedUsers: state.searchedUsers.map((userWithTrustStatus) {
          if (userWithTrustStatus.user.id == event.receiverId) {
            return UserWithTrustStatus(
              user: userWithTrustStatus.user,
              trustStatus: TrustStatus.requestSent,
            );
          }
          return userWithTrustStatus;
        }).toList(),
      ),
    );
  }

  void _onAcceptFriendRequest(
      AcceptFriendRequest event, Emitter<FriendshipsState> emit) async {
    emit(state.copyWith(status: FriendshipsStatus.loading));

    final friendRequest =
        await friendshipRepository.acceptFriendRequest(event.friendRequestId);

    emit(
      state.copyWith(
        status: FriendshipsStatus.success,
        friends: [
          friendRequest.sender,
          ...state.friends,
        ],
        receivedFriendRequests: state.receivedFriendRequests
            .where((request) => request.id != event.friendRequestId)
            .toList(),
        // updating the trust status of the user who sent the friend request
        searchedUsers: state.searchedUsers.map((userWithTrustStatus) {
          if (userWithTrustStatus.user.id == friendRequest.sender.id) {
            return UserWithTrustStatus(
              user: userWithTrustStatus.user,
              trustStatus: TrustStatus.trusted,
            );
          }
          return userWithTrustStatus;
        }).toList(),
      ),
    );
  }

  void _onFetchFriends(
      FetchFriends event, Emitter<FriendshipsState> emit) async {
    emit(state.copyWith(status: FriendshipsStatus.loading));
    final friends = await friendshipRepository.fetchFriends();
    emit(
      state.copyWith(
        status: FriendshipsStatus.success,
        friends: friends,
      ),
    );
  }

  void _onFetchUsersByName(
      FetchUsersByName event, Emitter<FriendshipsState> emit) async {
    emit(state.copyWith(status: FriendshipsStatus.loading));

    final List<User> searchedUsers =
        await userRepository.getUsersByName(event.name);
    final friends = state.friends;
    final sentFriendRequests = state.sentFriendRequests;
    final receivedFriendRequests = state.receivedFriendRequests;

    final usersWithTrustStatus = searchedUsers.map((user) {
      if (friends.any((friend) => friend.id == user.id)) {
        return UserWithTrustStatus(
            user: user, trustStatus: TrustStatus.trusted);
      } else if (sentFriendRequests
          .any((request) => request.receiver.id == user.id)) {
        return UserWithTrustStatus(
            user: user, trustStatus: TrustStatus.requestSent);
      } else if (receivedFriendRequests
          .any((request) => request.sender.id == user.id)) {
        return UserWithTrustStatus(
            user: user, trustStatus: TrustStatus.requestReceived);
      } else {
        return UserWithTrustStatus(user: user, trustStatus: TrustStatus.none);
      }
    }).toList();

    emit(
      state.copyWith(
        status: FriendshipsStatus.success,
        searchedUsers: usersWithTrustStatus,
      ),
    );
  }

  void _onFetchSentFriendRequests(
      FetchSentFriendRequests event, Emitter<FriendshipsState> emit) async {
    emit(state.copyWith(status: FriendshipsStatus.loading));

    final sentFriendRequests =
        await friendshipRepository.fetchSentFriendRequests();
    emit(
      state.copyWith(
        status: FriendshipsStatus.success,
        sentFriendRequests: sentFriendRequests,
      ),
    );
  }

  void _onFetchReceivedFriendRequests(
      FetchReceivedFriendRequests event, Emitter<FriendshipsState> emit) async {
    emit(state.copyWith(status: FriendshipsStatus.loading));

    final receivedFriendRequests =
        await friendshipRepository.fetchReceivedFriendRequests();
    emit(
      state.copyWith(
        status: FriendshipsStatus.success,
        receivedFriendRequests: receivedFriendRequests,
      ),
    );
  }
}
