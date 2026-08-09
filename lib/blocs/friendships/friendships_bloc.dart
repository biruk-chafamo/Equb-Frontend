import 'package:equatable/equatable.dart';
import 'package:equb_v3_frontend/blocs/common/guarded_bloc.dart';
import 'package:equb_v3_frontend/blocs/friendships/trust_status.dart';
import 'package:equb_v3_frontend/models/friendship/friend_request.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/repositories/friendship_respository.dart';
import 'package:equb_v3_frontend/repositories/user_repository.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'friendships_event.dart';
part 'friendships_state.dart';

class FriendshipsBloc extends Bloc<FriendshipsEvent, FriendshipsState>
    with GuardedBloc<FriendshipsEvent, FriendshipsState> {
  final FriendshipRepository friendshipRepository;
  final UserRepository userRepository;

  FriendshipsBloc(
      {required this.friendshipRepository, required this.userRepository})
      : super(const FriendshipsState()) {
    on<SendFriendRequest>(guarded(_onSendFriendRequest, onFailure: _failure));
    on<AcceptFriendRequest>(
        guarded(_onAcceptFriendRequest, onFailure: _failure));
    on<FetchFriends>(guarded(_onFetchFriends, onFailure: _failure));
    on<FetchUsersByName>(guarded(_onFetchUsersByName, onFailure: _failure));
    on<FetchSentFriendRequests>(
        guarded(_onFetchSentFriendRequests, onFailure: _failure));
    on<FetchReceivedFriendRequests>(
        guarded(_onFetchReceivedFriendRequests, onFailure: _failure));
    on<FetchFocusedUserFriends>(
        guarded(_onFetchFocusedUserFriends, onFailure: _failure));
  }

  FriendshipsState _failure(String message, Object? _) =>
      state.copyWith(status: FriendshipsStatus.failure, error: message);

  Future<void> _onSendFriendRequest(
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

  Future<void> _onAcceptFriendRequest(
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

  Future<void> _onFetchFriends(
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

  Future<void> _onFetchFocusedUserFriends(
      FetchFocusedUserFriends event, Emitter<FriendshipsState> emit) async {
    emit(state.copyWith(status: FriendshipsStatus.loading));

    final focusedUserFriends =
        await friendshipRepository.fetchFocusedUserFriends(event.userId);
    emit(
      state.copyWith(
        status: FriendshipsStatus.success,
        focusedUserFriends: focusedUserFriends,
      ),
    );
  }

  Future<void> _onFetchUsersByName(
      FetchUsersByName event, Emitter<FriendshipsState> emit) async {
    emit(state.copyWith(status: FriendshipsStatus.loading));

    final List<User> searchedUsers =
        await userRepository.getUsersByName(event.name);

    final usersWithTrustStatus = deriveTrustStatuses(
      searchedUsers: searchedUsers,
      friends: state.friends,
      sentRequests: state.sentFriendRequests,
      receivedRequests: state.receivedFriendRequests,
    );

    emit(
      state.copyWith(
        status: FriendshipsStatus.success,
        searchedUsers: usersWithTrustStatus,
      ),
    );
  }

  Future<void> _onFetchSentFriendRequests(
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

  Future<void> _onFetchReceivedFriendRequests(
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
