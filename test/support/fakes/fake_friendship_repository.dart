import 'package:equb_v3_frontend/models/friendship/friend_request.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/repositories/friendship_respository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../builders/friendship_builder.dart';

class FakeFriendshipRepository extends Fake implements FriendshipRepository {
  final List<String> calls = [];

  List<User> friendsResult = const [];
  List<User> focusedUserFriendsResult = const [];
  List<FriendRequest> sentRequestsResult = const [];
  List<FriendRequest> receivedRequestsResult = const [];
  FriendRequest? sendResult;
  FriendRequest? acceptResult;

  Object? nextError;

  void _maybeThrow() {
    final error = nextError;
    if (error != null) {
      nextError = null;
      throw error;
    }
  }

  @override
  Future<FriendRequest> sendFriendRequest(int receiverId) async {
    calls.add('sendFriendRequest($receiverId)');
    _maybeThrow();
    return sendResult ?? buildFriendRequest(id: receiverId);
  }

  @override
  Future<FriendRequest> acceptFriendRequest(int friendRequestId) async {
    calls.add('acceptFriendRequest($friendRequestId)');
    _maybeThrow();
    return acceptResult ??
        buildFriendRequest(id: friendRequestId, isAccepted: true);
  }

  @override
  Future<List<User>> fetchFriends() async {
    calls.add('fetchFriends()');
    _maybeThrow();
    return friendsResult;
  }

  @override
  Future<List<User>> fetchFocusedUserFriends(int userId) async {
    calls.add('fetchFocusedUserFriends($userId)');
    _maybeThrow();
    return focusedUserFriendsResult;
  }

  @override
  Future<List<FriendRequest>> fetchSentFriendRequests() async {
    calls.add('fetchSentFriendRequests()');
    _maybeThrow();
    return sentRequestsResult;
  }

  @override
  Future<List<FriendRequest>> fetchReceivedFriendRequests() async {
    calls.add('fetchReceivedFriendRequests()');
    _maybeThrow();
    return receivedRequestsResult;
  }
}
