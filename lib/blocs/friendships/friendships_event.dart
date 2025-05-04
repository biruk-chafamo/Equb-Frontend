part of 'friendships_bloc.dart';

sealed class FriendshipsEvent extends Equatable {
  const FriendshipsEvent();

  @override
  List<Object> get props => [];
}

class SendFriendRequest extends FriendshipsEvent {
  final int receiverId;

  const SendFriendRequest(this.receiverId);

  @override
  List<Object> get props => [receiverId];
}

class AcceptFriendRequest extends FriendshipsEvent {
  final int friendRequestId;

  const AcceptFriendRequest(this.friendRequestId);

  @override
  List<Object> get props => [friendRequestId];
}

class FetchFriends extends FriendshipsEvent {
  const FetchFriends();

  @override
  List<Object> get props => [];
}

class FetchFocusedUserFriends extends FriendshipsEvent {
  final int userId;
  const FetchFocusedUserFriends(this.userId);

  @override
  List<Object> get props => [userId];
}

class FetchUsersByName extends FriendshipsEvent {
  final String name;

  const FetchUsersByName(this.name);

  @override
  List<Object> get props => [name];
}

class FetchSentFriendRequests extends FriendshipsEvent {}

class FetchReceivedFriendRequests extends FriendshipsEvent {}
