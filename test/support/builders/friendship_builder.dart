import 'package:equb_v3_frontend/models/friendship/friend_request.dart';
import 'package:equb_v3_frontend/models/user/user.dart';

import 'user_builder.dart';

FriendRequest buildFriendRequest({
  int id = 1,
  User? sender,
  User? receiver,
  bool isAccepted = false,
  DateTime? creationDate,
}) {
  return FriendRequest(
    id: id,
    sender: sender ?? buildUser(id: 1),
    receiver: receiver ?? buildUser(id: 2),
    isAccepted: isAccepted,
    creationDate: creationDate ?? DateTime(2026, 3, 1),
  );
}
