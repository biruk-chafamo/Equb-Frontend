import 'package:equb_v3_frontend/models/friendship/friend_request.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/services/friendship_service.dart';

class FriendshipRepository {
  final FriendshipService friendshipService;

  const FriendshipRepository({required this.friendshipService});

  Future<FriendRequest> sendFriendRequest(int receiverId) async {
    final friendRequestJson =
        await friendshipService.sendFriendRequest(receiverId);

    return FriendRequest.fromJson(friendRequestJson);
  }

  Future<FriendRequest> acceptFriendRequest(int friendRequestId) async {
    final friendRequestJson =
        await friendshipService.acceptFriendRequest(friendRequestId);

    return FriendRequest.fromJson(friendRequestJson);
  }

  Future<List<User>> fetchFriends() async {
    final friendsJson = await friendshipService.fetchFriends();

    return friendsJson.map((dynamic item) => User.fromJson(item)).toList();
  }

  Future<List<FriendRequest>> fetchSentFriendRequests() async {
    final sentFriendRequestsJson =
        await friendshipService.fetchSentFriendRequests();

    return sentFriendRequestsJson
        .map((dynamic item) => FriendRequest.fromJson(item))
        .toList();
  }

  Future<List<FriendRequest>> fetchReceivedFriendRequests() async {
    final receivedFriendRequestsJson =
        await friendshipService.fetchReceivedFriendRequests();

    return receivedFriendRequestsJson
        .map((dynamic item) => FriendRequest.fromJson(item))
        .toList();
  }
}
