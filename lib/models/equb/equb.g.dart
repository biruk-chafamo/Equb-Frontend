// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equb.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Equb _$EqubFromJson(Map<String, dynamic> json) => Equb(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      amount: double.parse(json['amount'] as String),
      maxMembers: (json['max_members'] as num).toInt(),
      cycle: json['cycle'] as String,
      currentRound: (json['current_round'] as num).toInt(),
      creationDate: json['creation_date'] as String,
      isPrivate: json['is_private'] as bool,
      isActive: json['is_active'] as bool,
      isCompleted: json['is_completed'] as bool,
      isInPaymentStage: json['is_in_payment_stage'] as bool,
      members: (json['members'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EqubToJson(Equb instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'max_members': instance.maxMembers,
      'cycle': instance.cycle,
      'current_round': instance.currentRound,
      'creation_date': instance.creationDate,
      'is_private': instance.isPrivate,
      'is_active': instance.isActive,
      'is_completed': instance.isCompleted,
      'is_in_payment_stage': instance.isInPaymentStage,
      'members': instance.members,
    };
