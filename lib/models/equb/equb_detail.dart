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
  @JsonKey(name: 'current_highest_bidder')
  final User? currentHighestBidder;
  @JsonKey(name: 'percent_joined')
  final double percentJoined;
  @JsonKey(name: 'percent_completed')
  final double percentCompleted;
  @JsonKey(name: 'is_won_by_user')
  final bool isWonByUser;
  @JsonKey(name: 'user_payment_status')
  final PaymentStatus userPaymentStatus;
  @JsonKey(name: 'latest_winner')
  final User? latestWinner;
  @JsonKey(name: 'time_left_till_next_round')
  final Map<String, int> timeLeftTillNextRound;
  @JsonKey(name: 'rejected_payers')
  final List<User> rejectedPayers;
  @JsonKey(name: 'confirmed_payers')
  final List<User> confirmedPayers;
  @JsonKey(name: 'unconfirmed_payers')
  final List<User> unconfirmedPayers;
  @JsonKey(name: 'unpaid_members')
  final List<User> unpaidMembers;
  @JsonKey(name: 'current_user_is_member')
  final bool currentUserIsMember;
  @JsonKey(name: 'payment_collection_dates')
  final List<DateTime> paymentCollectionDates;
  @JsonKey(name: 'is_created_by_user')
  final bool isCreatedByUser;

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
    required this.currentHighestBidder,
    required this.percentJoined,
    required this.percentCompleted,
    required this.isWonByUser,
    required this.userPaymentStatus,
    required this.latestWinner,
    required this.timeLeftTillNextRound,
    required this.rejectedPayers,
    required this.confirmedPayers,
    required this.unconfirmedPayers,
    required this.unpaidMembers,
    required this.currentUserIsMember,
    required this.paymentCollectionDates,
    required this.isCreatedByUser,
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
