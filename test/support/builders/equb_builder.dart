import 'package:equb_v3_frontend/models/equb/equb.dart';
import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/utils/constants.dart';

Equb buildEqub({
  int id = 1,
  String name = 'Sunrise',
  double amount = 1200,
  int maxMembers = 6,
  String cycle = '7 00:00:00',
  int currentRound = 1,
  String creationDate = '2026-01-15T10:00:00Z',
  bool isPrivate = false,
  bool isActive = true,
  bool isCompleted = false,
  bool isInPaymentStage = false,
  List<UserSummary>? members,
}) {
  return Equb(
    id: id,
    name: name,
    amount: amount,
    maxMembers: maxMembers,
    cycle: cycle,
    currentRound: currentRound,
    creationDate: creationDate,
    isPrivate: isPrivate,
    isActive: isActive,
    isCompleted: isCompleted,
    isInPaymentStage: isInPaymentStage,
    members: members ?? const [],
  );
}

/// `paymentCollectionDates` defaults to dates around `DateTime.now()` because
/// `TableCalendar` asserts its focused day falls inside a window derived from
/// the current date; fixed dates would start failing that assert as they age.
EqubDetail buildEqubDetail({
  int id = 1,
  String name = 'Sunrise',
  double amount = 1200,
  int maxMembers = 6,
  String cycle = '7 00:00:00',
  int currentRound = 1,
  String creationDate = '2026-01-15T10:00:00Z',
  bool isPrivate = false,
  bool isActive = true,
  bool isCompleted = false,
  bool isInPaymentStage = false,
  List<UserSummary>? members,
  double currentAward = 1200,
  double currentHighestBid = 0,
  int? currentHighestBidderId,
  int? creatorId,
  double percentJoined = 100,
  double percentCompleted = 0,
  bool isWonByUser = false,
  PaymentStatus userPaymentStatus = PaymentStatus.unpaid,
  WinnerUser? latestWinner,
  Map<String, int>? timeLeftTillNextRound,
  List<int>? rejectedPayerIds,
  List<int>? confirmedPayerIds,
  List<int>? unconfirmedPayerIds,
  List<int>? unpaidMemberIds,
  bool currentUserIsMember = true,
  List<DateTime>? paymentCollectionDates,
  bool isCreatedByUser = false,
  int pendingJoinRequestCount = 0,
  String currentUserJoinRequestStatus = 'none',
}) {
  final now = DateTime.now();
  return EqubDetail(
    id: id,
    name: name,
    amount: amount,
    maxMembers: maxMembers,
    cycle: cycle,
    currentRound: currentRound,
    creationDate: creationDate,
    isPrivate: isPrivate,
    isActive: isActive,
    isCompleted: isCompleted,
    isInPaymentStage: isInPaymentStage,
    members: members ?? const [],
    currentAward: currentAward,
    currentHighestBid: currentHighestBid,
    currentHighestBidderId: currentHighestBidderId,
    creatorId: creatorId,
    percentJoined: percentJoined,
    percentCompleted: percentCompleted,
    isWonByUser: isWonByUser,
    userPaymentStatus: userPaymentStatus,
    latestWinner: latestWinner,
    timeLeftTillNextRound: timeLeftTillNextRound ??
        const {'days': 7, 'hours': 0, 'minutes': 0, 'seconds': 0},
    rejectedPayerIds: rejectedPayerIds ?? const [],
    confirmedPayerIds: confirmedPayerIds ?? const [],
    unconfirmedPayerIds: unconfirmedPayerIds ?? const [],
    unpaidMemberIds: unpaidMemberIds ?? const [],
    currentUserIsMember: currentUserIsMember,
    paymentCollectionDates: paymentCollectionDates ??
        [now.subtract(const Duration(days: 7)), now.add(const Duration(days: 7))],
    isCreatedByUser: isCreatedByUser,
    pendingJoinRequestCount: pendingJoinRequestCount,
    currentUserJoinRequestStatus: currentUserJoinRequestStatus,
  );
}
