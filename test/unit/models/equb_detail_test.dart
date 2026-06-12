import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/builders/equb_builder.dart';

void main() {
  group('formattedCycle', () {
    String formatted(String cycle) =>
        buildEqubDetail(cycle: cycle).formattedCycle();

    test('reports whole days for the day-bearing presets', () {
      expect(formatted('7 00:00:00'), '7 days');
      expect(formatted('30 00:00:00'), '30 days');
      expect(formatted('365 00:00:00'), '365 days');
    });

    test('singularises a one-day cycle', () {
      expect(formatted('1 00:00:00'), '1 day');
    });

    test('falls back to hours when there are no days', () {
      expect(formatted('02:00:00'), '2 hrs');
      expect(formatted('01:30:00'), '1 hr');
    });

    test('falls back to minutes when there are no hours', () {
      expect(formatted('00:30:00'), '30 mins');
      expect(formatted('00:01:00'), '1 min');
    });

    test('falls back to seconds when there is nothing larger', () {
      expect(formatted('00:00:45'), '45 secs');
      expect(formatted('00:00:01'), '1 sec');
    });

    test('reports the largest non-zero unit only', () {
      expect(formatted('3 04:05:06'), '3 days');
      expect(formatted('04:05:06'), '4 hrs');
    });

    test('reads a bare colon-less value as seconds', () {
      expect(formatted('90'), '90 secs');
    });

    test('degrades to zero seconds on unparseable input', () {
      expect(formatted(''), '0 secs');
      expect(formatted('not a duration'), '0 secs');
    });
  });

  group('derived values', () {
    test('perPersonContribution splits the award across the members', () {
      final equb = buildEqubDetail(currentAward: 1200, maxMembers: 6);
      expect(equb.perPersonContribution, 200);
    });

    test('perPersonContribution is zero rather than infinite when empty', () {
      final equb = buildEqubDetail(currentAward: 1200, maxMembers: 0);
      expect(equb.perPersonContribution, 0);
    });

    test('highestBidPercent scales the fractional bid', () {
      expect(buildEqubDetail(currentHighestBid: 0.025).highestBidPercent,
          closeTo(2.5, 1e-9));
      expect(buildEqubDetail(currentHighestBid: 0).highestBidPercent, 0);
    });

    test('isFinalRound is true from the last round onward', () {
      expect(buildEqubDetail(currentRound: 5, maxMembers: 6).isFinalRound,
          isFalse);
      expect(
          buildEqubDetail(currentRound: 6, maxMembers: 6).isFinalRound, isTrue);
      expect(
          buildEqubDetail(currentRound: 7, maxMembers: 6).isFinalRound, isTrue);
    });
  });

  group('serialization', () {
    test('parses a payload in the shape the backend actually sends', () {
      final equb = EqubDetail.fromJson(_backendPayload());

      expect(equb.id, 7);
      expect(equb.amount, 1200.0);
      expect(equb.currentAward, 1140.0);
      expect(equb.currentHighestBid, 0.025);
      expect(equb.cycle, '7 00:00:00');
      expect(equb.timeLeftTillNextRound['days'], 3);
      expect(equb.paymentCollectionDates.first, DateTime.parse('2026-02-01T10:00:00Z'));
      expect(equb.currentHighestBidder, isNull);
      expect(equb.latestWinner, isNull);
    });

    test('amount must arrive as a string but the awards as numbers', () {
      expect(
        () => EqubDetail.fromJson(_backendPayload(amount: 1200.0)),
        throwsA(isA<TypeError>()),
      );
      expect(
        () => EqubDetail.fromJson(_backendPayload(currentAward: '1140.00')),
        throwsA(isA<TypeError>()),
      );
    });

    test('an unknown payment status is rejected outright', () {
      expect(
        () => EqubDetail.fromJson(_backendPayload(userPaymentStatus: 'forfeit')),
        throwsArgumentError,
      );
    });

    test('toJson does not round-trip back through fromJson', () {
      final equb = buildEqubDetail();

      expect(
        () => EqubDetail.fromJson(equb.toJson()),
        throwsA(isA<TypeError>()),
        reason: 'toJson writes amount as a double; fromJson demands a string',
      );
    });
  });
}

Map<String, dynamic> _backendPayload({
  Object amount = '1200.00',
  Object currentAward = 1140.0,
  String userPaymentStatus = 'unpaid',
}) {
  return {
    'id': 7,
    'name': 'Sunrise',
    'amount': amount,
    'max_members': 6,
    'cycle': '7 00:00:00',
    'current_round': 2,
    'creation_date': '2026-01-15T10:00:00Z',
    'is_private': false,
    'is_active': true,
    'is_completed': false,
    'is_in_payment_stage': false,
    'members': <Map<String, dynamic>>[],
    'current_award': currentAward,
    'current_highest_bid': 0.025,
    'current_highest_bidder': null,
    'percent_joined': 100.0,
    'percent_completed': 16.67,
    'is_won_by_user': false,
    'user_payment_status': userPaymentStatus,
    'latest_winner': null,
    'time_left_till_next_round': {
      'days': 3,
      'hours': 4,
      'minutes': 5,
      'seconds': 6,
    },
    'rejected_payers': <Map<String, dynamic>>[],
    'confirmed_payers': <Map<String, dynamic>>[],
    'unconfirmed_payers': <Map<String, dynamic>>[],
    'unpaid_members': <Map<String, dynamic>>[],
    'current_user_is_member': true,
    'payment_collection_dates': ['2026-02-01T10:00:00Z'],
    'is_created_by_user': false,
  };
}
