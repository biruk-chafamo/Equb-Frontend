import 'package:equb_v3_frontend/models/equb_join_request/equb_join_request.dart';
import 'package:equb_v3_frontend/models/user/user.dart';

import 'user_builder.dart';

EqubJoinRequest buildEqubJoinRequest({
  int id = 1,
  UserSummary? sender,
  UserSummary? receiver,
  int equbId = 1,
  bool isAccepted = false,
  bool isRejected = false,
  bool isExpired = false,
  int approvals = 0,
  int rejections = 0,
  int? requiredApprovals = 2,
  bool? currentUserVote,
  List<UserSummary>? trustedBy,
  int? trustedByCount,
  DateTime? creationDate,
}) {
  final trusted = trustedBy ?? const <UserSummary>[];
  return EqubJoinRequest(
    id: id,
    sender: sender ?? buildUser(id: 9),
    receiver: receiver ?? buildUser(id: 2),
    equbId: equbId,
    isAccepted: isAccepted,
    isRejected: isRejected,
    isExpired: isExpired,
    approvals: approvals,
    rejections: rejections,
    requiredApprovals: requiredApprovals,
    currentUserVote: currentUserVote,
    trustedBy: trusted,
    trustedByCount: trustedByCount ?? trusted.length,
    creationDate: creationDate ?? DateTime(2026, 3, 1),
  );
}
