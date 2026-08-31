import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/models/equb/equb.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'equb_detail.g.dart';

@JsonSerializable()
class EqubDetail extends Equb {
  @JsonKey(name: 'current_award')
  final double currentAward;
  @JsonKey(name: 'current_highest_bid')
  final double currentHighestBid;
  @JsonKey(name: 'current_highest_bidder_id')
  final int? currentHighestBidderId;
  @JsonKey(name: 'creator_id')
  final int? creatorId;
  @JsonKey(name: 'percent_joined')
  final double percentJoined;
  @JsonKey(name: 'percent_completed')
  final double percentCompleted;
  @JsonKey(name: 'is_won_by_user')
  final bool isWonByUser;
  @JsonKey(name: 'user_payment_status')
  final PaymentStatus userPaymentStatus;
  @JsonKey(name: 'latest_winner')
  final WinnerUser? latestWinner;
  @JsonKey(name: 'time_left_till_next_round')
  final Map<String, int> timeLeftTillNextRound;
  @JsonKey(name: 'rejected_payer_ids', defaultValue: <int>[])
  final List<int> rejectedPayerIds;
  @JsonKey(name: 'confirmed_payer_ids', defaultValue: <int>[])
  final List<int> confirmedPayerIds;
  @JsonKey(name: 'unconfirmed_payer_ids', defaultValue: <int>[])
  final List<int> unconfirmedPayerIds;
  @JsonKey(name: 'unpaid_member_ids', defaultValue: <int>[])
  final List<int> unpaidMemberIds;
  @JsonKey(name: 'current_user_is_member')
  final bool currentUserIsMember;
  @JsonKey(name: 'payment_collection_dates', defaultValue: <DateTime>[])
  final List<DateTime> paymentCollectionDates;
  @JsonKey(name: 'is_created_by_user', defaultValue: false)
  final bool isCreatedByUser;
  @JsonKey(name: 'pending_join_request_count', defaultValue: 0)
  final int pendingJoinRequestCount;
  @JsonKey(name: 'current_user_join_request_status', defaultValue: 'none')
  final String currentUserJoinRequestStatus;
  @JsonKey(name: 'join_approval_policy', defaultValue: 'majority')
  final String joinApprovalPolicy;

  const EqubDetail({
    required super.id,
    required super.name,
    required super.amount,
    required super.maxMembers,
    required super.cycle,
    required super.currentRound,
    required super.creationDate,
    required super.isPrivate,
    required super.isActive,
    required super.isCompleted,
    required super.isInPaymentStage,
    required super.members,
    required this.currentAward,
    required this.currentHighestBid,
    required this.currentHighestBidderId,
    required this.creatorId,
    required this.percentJoined,
    required this.percentCompleted,
    required this.isWonByUser,
    required this.userPaymentStatus,
    required this.latestWinner,
    required this.timeLeftTillNextRound,
    required this.rejectedPayerIds,
    required this.confirmedPayerIds,
    required this.unconfirmedPayerIds,
    required this.unpaidMemberIds,
    required this.currentUserIsMember,
    required this.paymentCollectionDates,
    required this.isCreatedByUser,
    required this.pendingJoinRequestCount,
    required this.currentUserJoinRequestStatus,
    required this.joinApprovalPolicy,
  });

  factory EqubDetail.fromJson(Map<String, dynamic> json) {
    return _$EqubDetailFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$EqubDetailToJson(this);

  String formattedCycle() {
    List<String> parts = cycle.split(RegExp(r'[: ]'));

    int days = 0, hours = 0, minutes = 0, seconds = 0;

    if (parts.length == 4) {
      days = int.tryParse(parts[0]) ?? 0;
      hours = int.tryParse(parts[1]) ?? 0;
      minutes = int.tryParse(parts[2]) ?? 0;
      seconds = int.tryParse(parts[3]) ?? 0;
    } else if (parts.length == 3) {
      hours = int.tryParse(parts[0]) ?? 0;
      minutes = int.tryParse(parts[1]) ?? 0;
      seconds = int.tryParse(parts[2]) ?? 0;
    } else if (parts.length == 2) {
      minutes = int.tryParse(parts[0]) ?? 0;
      seconds = int.tryParse(parts[1]) ?? 0;
    } else if (parts.length == 1) {
      seconds = int.tryParse(parts[0]) ?? 0;
    }

    if (days >= 1) {
      return '$days day${days != 1 ? 's' : ''}';
    } else if (hours >= 1) {
      return '$hours hr${hours != 1 ? 's' : ''}';
    } else if (minutes >= 1) {
      return '$minutes min${minutes != 1 ? 's' : ''}';
    } else {
      return '$seconds sec${seconds != 1 ? 's' : ''}';
    }
  }
}

/// An extension rather than class members so that a `build_runner` regen cannot
/// pick these up as serialized fields.
extension EqubDetailDerived on EqubDetail {
  double get perPersonContribution =>
      maxMembers == 0 ? 0 : currentAward / maxMembers;

  double get highestBidPercent => currentHighestBid * 100;

  bool get isFinalRound => currentRound >= maxMembers;

  Map<int, UserSummary> get _membersById => {for (final m in members) m.id: m};

  UserSummary? memberById(int? id) => id == null ? null : _membersById[id];

  /// Resolves id references against [members]; unresolvable ids are dropped.
  List<UserSummary> membersByIds(List<int> ids) {
    final index = _membersById;
    return ids.map((id) => index[id]).whereType<UserSummary>().toList();
  }

  UserSummary? get creator => memberById(creatorId);

  UserSummary? get currentHighestBidder => memberById(currentHighestBidderId);

  List<UserSummary> get unpaidMembers => membersByIds(unpaidMemberIds);
}
