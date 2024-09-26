// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) =>
    FriendRequest(
      id: (json['id'] as num).toInt(),
      sender: User.fromJson(json['sender'] as Map<String, dynamic>),
      receiver: User.fromJson(json['receiver'] as Map<String, dynamic>),
      isAccepted: json['is_accepted'] as bool,
      creationDate: DateTime.parse(json['creation_date'] as String),
    );

Map<String, dynamic> _$FriendRequestToJson(FriendRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'is_accepted': instance.isAccepted,
      'creation_date': instance.creationDate.toIso8601String(),
    };
