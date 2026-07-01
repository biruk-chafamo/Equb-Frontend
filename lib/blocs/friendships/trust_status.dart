import 'package:equb_v3_frontend/models/friendship/friend_request.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/utils/constants.dart';

List<UserWithTrustStatus> deriveTrustStatuses({
  required List<User> searchedUsers,
  required List<User> friends,
  required List<FriendRequest> sentRequests,
  required List<FriendRequest> receivedRequests,
}) {
  return searchedUsers.map((user) {
    if (friends.any((friend) => friend.id == user.id)) {
      return UserWithTrustStatus(user: user, trustStatus: TrustStatus.trusted);
    }
    if (sentRequests.any((request) => request.receiver.id == user.id)) {
      return UserWithTrustStatus(
          user: user, trustStatus: TrustStatus.requestSent);
    }
    if (receivedRequests.any((request) => request.sender.id == user.id)) {
      return UserWithTrustStatus(
          user: user, trustStatus: TrustStatus.requestReceived);
    }
    return UserWithTrustStatus(user: user, trustStatus: TrustStatus.none);
  }).toList();
}
