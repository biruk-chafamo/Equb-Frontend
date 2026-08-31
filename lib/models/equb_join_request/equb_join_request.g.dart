// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equb_join_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EqubJoinRequest _$EqubJoinRequestFromJson(Map<String, dynamic> json) =>
    EqubJoinRequest(
      id: (json['id'] as num).toInt(),
      sender: UserSummary.fromJson(json['sender'] as Map<String, dynamic>),
      receiver: UserSummary.fromJson(json['receiver'] as Map<String, dynamic>),
      equbId: (json['equb_id'] as num).toInt(),
      isAccepted: json['is_accepted'] as bool,
      isRejected: json['is_rejected'] as bool,
      isExpired: json['is_expired'] as bool,
      approvals: (json['approvals'] as num).toInt(),
      rejections: (json['rejections'] as num).toInt(),
      requiredApprovals: (json['required_approvals'] as num?)?.toInt(),
      currentUserVote: json['current_user_vote'] as bool?,
      trustedBy: (json['trusted_by'] as List<dynamic>?)
              ?.map((e) => UserSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      trustedByCount: (json['trusted_by_count'] as num?)?.toInt() ?? 0,
      creationDate: DateTime.parse(json['creation_date'] as String),
    );

Map<String, dynamic> _$EqubJoinRequestToJson(EqubJoinRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'equb_id': instance.equbId,
      'is_accepted': instance.isAccepted,
      'is_rejected': instance.isRejected,
      'is_expired': instance.isExpired,
      'approvals': instance.approvals,
      'rejections': instance.rejections,
      'required_approvals': instance.requiredApprovals,
      'current_user_vote': instance.currentUserVote,
      'trusted_by': instance.trustedBy,
      'trusted_by_count': instance.trustedByCount,
      'creation_date': instance.creationDate.toIso8601String(),
    };
