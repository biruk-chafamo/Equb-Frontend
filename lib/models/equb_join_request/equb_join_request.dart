import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'equb_join_request.g.dart';

@JsonSerializable()
class EqubJoinRequest {
  final int id;
  final UserSummary sender;
  final UserSummary receiver;
  @JsonKey(name: 'equb_id')
  final int equbId;
  @JsonKey(name: 'is_accepted')
  final bool isAccepted;
  @JsonKey(name: 'is_rejected')
  final bool isRejected;
  @JsonKey(name: 'is_expired')
  final bool isExpired;
  final int approvals;
  final int rejections;
  @JsonKey(name: 'required_approvals')
  final int? requiredApprovals;
  @JsonKey(name: 'current_user_vote')
  final bool? currentUserVote;
  @JsonKey(name: 'trusted_by', defaultValue: <UserSummary>[])
  final List<UserSummary> trustedBy;
  @JsonKey(name: 'trusted_by_count', defaultValue: 0)
  final int trustedByCount;
  @JsonKey(name: 'creation_date', fromJson: DateTime.parse)
  final DateTime creationDate;

  const EqubJoinRequest({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.equbId,
    required this.isAccepted,
    required this.isRejected,
    required this.isExpired,
    required this.approvals,
    required this.rejections,
    required this.requiredApprovals,
    required this.currentUserVote,
    required this.trustedBy,
    required this.trustedByCount,
    required this.creationDate,
  });

  factory EqubJoinRequest.fromJson(Map<String, dynamic> json) =>
      _$EqubJoinRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EqubJoinRequestToJson(this);

  bool get isDecided => isAccepted || isRejected || isExpired;

  EqubJoinRequest copyWith({
    bool? isAccepted,
    bool? isRejected,
    int? approvals,
    int? rejections,
    bool? currentUserVote,
  }) {
    return EqubJoinRequest(
      id: id,
      sender: sender,
      receiver: receiver,
      equbId: equbId,
      isAccepted: isAccepted ?? this.isAccepted,
      isRejected: isRejected ?? this.isRejected,
      isExpired: isExpired,
      approvals: approvals ?? this.approvals,
      rejections: rejections ?? this.rejections,
      requiredApprovals: requiredApprovals,
      currentUserVote: currentUserVote ?? this.currentUserVote,
      trustedBy: trustedBy,
      trustedByCount: trustedByCount,
      creationDate: creationDate,
    );
  }
}
