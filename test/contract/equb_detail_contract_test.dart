import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/fixture_reader.dart';
import 'fixture_paths.dart';

void main() {
  group('every captured lifecycle state parses', () {
    equbDetailByState.forEach((state, path) {
      test(state, () {
        final equb = EqubDetail.fromJson(jsonFixture(path));

        expect(equb.currentRound, inInclusiveRange(1, equb.maxMembers));
        expect(equb.members.length, lessThanOrEqualTo(equb.maxMembers));
        expect(PaymentStatus.values, contains(equb.userPaymentStatus));
        expect(equb.timeLeftTillNextRound.keys,
            containsAll(<String>['days', 'hours', 'minutes', 'seconds']));
        expect(equb.formattedCycle(), isNotEmpty);
      });
    });
  });

  group('money typing', () {
    test('amount is a string while the awards are numbers', () {
      final json = jsonFixture(equbDetailActiveBid);

      expect(json['amount'], isA<String>());
      expect(json['current_award'], isA<num>());
      expect(json['current_award'], isNot(isA<String>()));
      expect(json['current_highest_bid'], isA<num>());
    });

    test('the award never exceeds the pot it comes out of', () {
      for (final path in equbDetailByState.values) {
        final equb = EqubDetail.fromJson(jsonFixture(path));

        expect(equb.currentAward, greaterThan(0), reason: path);
        expect(equb.currentAward, lessThanOrEqualTo(equb.amount + 1e-9),
            reason: path);
      }
    });

    test('a bare integer zero parses as a bid of nothing', () {
      final json = jsonFixture(equbDetailFinalRound);

      expect(json['current_highest_bid'], isA<num>());
      expect(json['current_highest_bid'], isNot(isA<double>()));
      expect(json['current_highest_bidder'], isNull);
      expect(EqubDetail.fromJson(json).currentHighestBid, 0.0);
    });
  });

  group('countdown', () {
    test('a round that has not started reports all zeros', () {
      final equb = EqubDetail.fromJson(jsonFixture(equbDetailPending));

      expect(equb.timeLeftTillNextRound.values, everyElement(0));
      expect(equb.paymentCollectionDates, isEmpty);
    });

    test('every unit is an int and the sub-day units stay in range', () {
      for (final path in equbDetailByState.values) {
        final left =
            EqubDetail.fromJson(jsonFixture(path)).timeLeftTillNextRound;

        expect(left.values, everyElement(isA<int>()), reason: path);
        expect(left['hours'], inInclusiveRange(0, 23), reason: path);
        expect(left['minutes'], inInclusiveRange(0, 59), reason: path);
        expect(left['seconds'], inInclusiveRange(0, 59), reason: path);
      }
    });
  });

  group('lifecycle flags', () {
    test('a completed equb is still flagged active', () {
      final json = jsonFixture(equbDetailCompleted);

      expect(json['is_completed'], isTrue);
      expect(json['is_active'], isTrue);
      expect(json['end_date'], isNotNull);
      expect(json['percent_completed'], 100.0);
    });

    test('an equb we were only invited to reports us as a non-member', () {
      final equb = EqubDetail.fromJson(jsonFixture(equbDetailInvited));

      expect(equb.currentUserIsMember, isFalse);
      expect(equb.isCreatedByUser, isFalse);
    });

    test('the payment stage names a winner and holds unpaid members', () {
      final equb = EqubDetail.fromJson(jsonFixture(equbDetailPaymentStage));

      expect(equb.isInPaymentStage, isTrue);
      expect(equb.latestWinner, isNotNull);
      expect(
        equb.unconfirmedPayerIds.length + equb.unpaidMemberIds.length,
        greaterThan(0),
      );
    });

    test('the winner sees themselves as the winner', () {
      final equb =
          EqubDetail.fromJson(jsonFixture(equbDetailPaymentStageWinner));

      expect(equb.userPaymentStatus, PaymentStatus.winner);
      expect(equb.isWonByUser, isTrue);
    });
  });

  group('lists', () {
    test('the active list parses every entry', () {
      final equbs = jsonListFixture(equbsActive)
          .cast<Map<String, dynamic>>()
          .map(EqubDetail.fromJson)
          .toList();

      expect(equbs, isNotEmpty);
      expect(equbs.every((e) => e.isActive), isTrue);
    });

    test('the invited list contains only equbs we have not joined', () {
      final equbs = jsonListFixture(equbsInvited)
          .cast<Map<String, dynamic>>()
          .map(EqubDetail.fromJson)
          .toList();

      expect(equbs, isNotEmpty);
      expect(equbs.every((e) => e.currentUserIsMember), isFalse);
    });

    test('the recommended list is reachable and parses', () {
      final equbs = jsonListFixture(equbsRecommended)
          .cast<Map<String, dynamic>>()
          .map(EqubDetail.fromJson)
          .toList();

      expect(equbs, isNotEmpty);
    });
  });

  group('cycle', () {
    test('is a django duration string the hand parser understands', () {
      final json = jsonFixture(equbDetailActiveBid);

      expect(json['cycle'], isA<String>());
      expect(EqubDetail.fromJson(json).formattedCycle(), '7 days');
    });
  });

  group('timestamps', () {
    test('arrive as utc iso-8601 with a trailing z', () {
      final samples = jsonFixture(timestampSamples);

      expect(samples['creation_date'], endsWith('Z'));
      expect(DateTime.tryParse(samples['creation_date'] as String), isNotNull);

      for (final date in samples['payment_collection_dates'] as List<dynamic>) {
        expect(date, endsWith('Z'));
        expect(DateTime.tryParse(date as String), isNotNull);
      }
    });
  });
}
