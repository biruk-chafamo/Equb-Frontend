// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equb_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EqubDetail _$EqubDetailFromJson(Map<String, dynamic> json) => EqubDetail(
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
      currentAward: (json['current_award'] as num).toDouble(),
      currentHighestBid: (json['current_highest_bid'] as num).toDouble(),
      currentHighestBidder: json['current_highest_bidder'] == null
          ? null
          : User.fromJson(
              json['current_highest_bidder'] as Map<String, dynamic>),
      percentJoined: (json['percent_joined'] as num).toDouble(),
      percentCompleted: (json['percent_completed'] as num).toDouble(),
      isWonByUser: json['is_won_by_user'] as bool,
      userPaymentStatus:
          $enumDecode(_$PaymentStatusEnumMap, json['user_payment_status']),
      latestWinner: json['latest_winner'] == null
          ? null
          : User.fromJson(json['latest_winner'] as Map<String, dynamic>),
      timeLeftTillNextRound:
          Map<String, int>.from(json['time_left_till_next_round'] as Map),
      rejectedPayers: (json['rejected_payers'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      confirmedPayers: (json['confirmed_payers'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      unconfirmedPayers: (json['unconfirmed_payers'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      unpaidMembers: (json['unpaid_members'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentUserIsMember: json['current_user_is_member'] as bool,
      paymentCollectionDates:
          (json['payment_collection_dates'] as List<dynamic>)
              .map((e) => DateTime.parse(e as String))
              .toList(),
      isCreatedByUser: json['is_created_by_user'] as bool,
    );

Map<String, dynamic> _$EqubDetailToJson(EqubDetail instance) =>
    <String, dynamic>{
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
      'current_award': instance.currentAward,
      'current_highest_bid': instance.currentHighestBid,
      'current_highest_bidder': instance.currentHighestBidder,
      'percent_joined': instance.percentJoined,
      'percent_completed': instance.percentCompleted,
      'is_won_by_user': instance.isWonByUser,
      'user_payment_status':
          _$PaymentStatusEnumMap[instance.userPaymentStatus]!,
      'latest_winner': instance.latestWinner,
      'time_left_till_next_round': instance.timeLeftTillNextRound,
      'rejected_payers': instance.rejectedPayers,
      'confirmed_payers': instance.confirmedPayers,
      'unconfirmed_payers': instance.unconfirmedPayers,
      'unpaid_members': instance.unpaidMembers,
      'current_user_is_member': instance.currentUserIsMember,
      'payment_collection_dates': instance.paymentCollectionDates
          .map((e) => e.toIso8601String())
          .toList(),
      'is_created_by_user': instance.isCreatedByUser,
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.winner: 'winner',
  PaymentStatus.confirmed: 'confirmed',
  PaymentStatus.unconfirmed: 'unconfirmed',
  PaymentStatus.rejected: 'rejected',
  PaymentStatus.unpaid: 'unpaid',
};
