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
          .map((e) => UserSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentAward: (json['current_award'] as num).toDouble(),
      currentHighestBid: (json['current_highest_bid'] as num).toDouble(),
      currentHighestBidderId:
          (json['current_highest_bidder_id'] as num?)?.toInt(),
      creatorId: (json['creator_id'] as num?)?.toInt(),
      percentJoined: (json['percent_joined'] as num).toDouble(),
      percentCompleted: (json['percent_completed'] as num).toDouble(),
      isWonByUser: json['is_won_by_user'] as bool,
      userPaymentStatus:
          $enumDecode(_$PaymentStatusEnumMap, json['user_payment_status']),
      latestWinner: json['latest_winner'] == null
          ? null
          : WinnerUser.fromJson(json['latest_winner'] as Map<String, dynamic>),
      timeLeftTillNextRound:
          Map<String, int>.from(json['time_left_till_next_round'] as Map),
      rejectedPayerIds: (json['rejected_payer_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      confirmedPayerIds: (json['confirmed_payer_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      unconfirmedPayerIds: (json['unconfirmed_payer_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      unpaidMemberIds: (json['unpaid_member_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      currentUserIsMember: json['current_user_is_member'] as bool,
      paymentCollectionDates:
          (json['payment_collection_dates'] as List<dynamic>?)
                  ?.map((e) => DateTime.parse(e as String))
                  .toList() ??
              [],
      isCreatedByUser: json['is_created_by_user'] as bool? ?? false,
      pendingJoinRequestCount:
          (json['pending_join_request_count'] as num?)?.toInt() ?? 0,
      currentUserJoinRequestStatus:
          json['current_user_join_request_status'] as String? ?? 'none',
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
      'current_highest_bidder_id': instance.currentHighestBidderId,
      'creator_id': instance.creatorId,
      'percent_joined': instance.percentJoined,
      'percent_completed': instance.percentCompleted,
      'is_won_by_user': instance.isWonByUser,
      'user_payment_status':
          _$PaymentStatusEnumMap[instance.userPaymentStatus]!,
      'latest_winner': instance.latestWinner,
      'time_left_till_next_round': instance.timeLeftTillNextRound,
      'rejected_payer_ids': instance.rejectedPayerIds,
      'confirmed_payer_ids': instance.confirmedPayerIds,
      'unconfirmed_payer_ids': instance.unconfirmedPayerIds,
      'unpaid_member_ids': instance.unpaidMemberIds,
      'current_user_is_member': instance.currentUserIsMember,
      'payment_collection_dates': instance.paymentCollectionDates
          .map((e) => e.toIso8601String())
          .toList(),
      'is_created_by_user': instance.isCreatedByUser,
      'pending_join_request_count': instance.pendingJoinRequestCount,
      'current_user_join_request_status': instance.currentUserJoinRequestStatus,
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.winner: 'winner',
  PaymentStatus.confirmed: 'confirmed',
  PaymentStatus.unconfirmed: 'unconfirmed',
  PaymentStatus.rejected: 'rejected',
  PaymentStatus.unpaid: 'unpaid',
};
