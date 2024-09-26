// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equb_invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EqubInvite _$EqubInviteFromJson(Map<String, dynamic> json) => EqubInvite(
      id: (json['id'] as num).toInt(),
      equbDetail: EqubDetail.fromJson(json['equb'] as Map<String, dynamic>),
      receiver: User.fromJson(json['receiver'] as Map<String, dynamic>),
      isAccepted: json['is_accepted'] as bool,
      isRejected: json['is_rejected'] as bool,
      creationDate: DateTime.parse(json['creation_date'] as String),
    );

Map<String, dynamic> _$EqubInviteToJson(EqubInvite instance) =>
    <String, dynamic>{
      'id': instance.id,
      'equb': instance.equbDetail,
      'receiver': instance.receiver,
      'is_accepted': instance.isAccepted,
      'is_rejected': instance.isRejected,
      'creation_date': instance.creationDate.toIso8601String(),
    };
