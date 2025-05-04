part of 'friendships_bloc.dart';

enum FriendshipsStatus { initial, loading, success, failure }

class FriendshipsState extends Equatable {
  const FriendshipsState({
    this.friends = const [],
    this.error,
    this.status = FriendshipsStatus.initial,
    this.sentFriendRequests = const [],
    this.receivedFriendRequests = const [],
    this.searchedUsers = const [],
    this.focusedUserFriends = const [],
  });

  final List<User> friends;
  final String? error;
  final FriendshipsStatus status;
  final List<FriendRequest> sentFriendRequests;
  final List<FriendRequest> receivedFriendRequests;
  final List<UserWithTrustStatus> searchedUsers;
  final List<User> focusedUserFriends;

  @override
  List<Object?> get props => [
        status,
        friends,
        sentFriendRequests,
        receivedFriendRequests,
        searchedUsers,
        focusedUserFriends,
        error
      ];

  FriendshipsState copyWith({
    FriendshipsStatus? status,
    List<User>? friends,
    String? error,
    List<FriendRequest>? sentFriendRequests,
    List<FriendRequest>? receivedFriendRequests,
    List<UserWithTrustStatus>? searchedUsers,
    List<User>? focusedUserFriends,
  }) {
    return FriendshipsState(
      status: status ?? this.status,
      friends: friends ?? this.friends,
      error: error ?? this.error,
      sentFriendRequests: sentFriendRequests ?? this.sentFriendRequests,
      receivedFriendRequests:
          receivedFriendRequests ?? this.receivedFriendRequests,
      searchedUsers: searchedUsers ?? this.searchedUsers,
      focusedUserFriends: focusedUserFriends ?? this.focusedUserFriends,
    );
  }
}
