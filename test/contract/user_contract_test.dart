import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/fixture_reader.dart';
import 'fixture_paths.dart';

void main() {
  group('the current user', () {
    test('parses', () {
      final user = User.fromJson(jsonFixture(userCurrent));

      expect(user.username, isNotEmpty);
      expect(user.firstName, isNotEmpty);
      expect(user.score, greaterThan(0));
    });

    test('score is a string on the wire', () {
      final json = jsonFixture(userCurrent);

      expect(json['score'], isA<String>());
      expect(double.tryParse(json['score'] as String), isNotNull);
    });

    test('carries snake_case keys and a nullable profile picture', () {
      final json = jsonFixture(userCurrent);

      expect(json.keys, containsAll(<String>['first_name', 'last_name']));
      expect(json.keys, containsAll(<String>['joined_equbs', 'profile_picture']));
      expect(json.keys, contains('selected_payment_methods'));
    });

    test('friends and joined equbs are id lists, not objects', () {
      final json = jsonFixture(userCurrent);

      expect(json['friends'], everyElement(isA<int>()));
      expect(json['joined_equbs'], everyElement(isA<int>()));
    });

    test('every user carries at least a default payment method', () {
      final user = User.fromJson(jsonFixture(userCurrent));

      expect(user.paymentMethods, isNotEmpty);
      expect(user.paymentMethods.first.service, isNotEmpty);
    });

    test('bank_account is not exposed by the list serializer', () {
      expect(jsonFixture(userCurrent).keys, isNot(contains('bank_account')));
    });
  });

  group('friends', () {
    test('is a bare array of users', () {
      final friends = jsonListFixture(usersFriends)
          .cast<Map<String, dynamic>>()
          .map(User.fromJson)
          .toList();

      expect(friends, isNotEmpty);
      expect(friends.every((f) => f.username.isNotEmpty), isTrue);
    });
  });

  group('search', () {
    test('is the only paginated endpoint', () {
      final page = jsonFixture(usersSearch);

      expect(page.keys,
          containsAll(<String>['count', 'next', 'previous', 'results']));
      expect(page['count'], isA<int>());
      expect(page['results'], isA<List<dynamic>>());
    });

    test('results parse as users', () {
      final results = (jsonFixture(usersSearch)['results'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(User.fromJson)
          .toList();

      expect(results, isNotEmpty);
    });

    test('results are ordered, so pages cannot overlap', () {
      final ids = (jsonFixture(usersSearch)['results'] as List<dynamic>)
          .map((u) => (u as Map<String, dynamic>)['id'] as int)
          .toList();

      expect(ids, orderedEquals(ids.toList()..sort()));
    });
  });

  group('a user nested inside an equb', () {
    Map<String, dynamic> firstEqub() =>
        (jsonListFixture(equbsActive).first as Map<String, dynamic>);

    test('carries only what a member row renders', () {
      final member =
          (firstEqub()['members'] as List<dynamic>).first as Map<String, dynamic>;

      expect(
        member.keys.toSet(),
        equals(<String>{'id', 'first_name', 'last_name', 'score', 'profile_picture'}),
      );
    });

    test('the winner alone carries payment methods', () {
      final winner = firstEqub()['latest_winner'] as Map<String, dynamic>?;

      expect(winner, isNotNull);
      expect(winner!.keys, contains('selected_payment_methods'));
      expect(winner['selected_payment_methods'], isA<List<dynamic>>());
    });

    test('users fetched in their own right keep the full shape', () {
      final self = jsonFixture(userCurrent);

      expect(self.keys,
          containsAll(<String>['username', 'friends', 'joined_equbs']));
    });
  });

  group('references between users in one response', () {
    test('every id an equb names resolves to one of its members', () {
      for (final path in equbDetailByState.values) {
        final json = jsonFixture(path);
        final equb = EqubDetail.fromJson(json);
        final memberIds = equb.members.map((m) => m.id).toSet();

        final referenced = <int>[
          ...equb.unpaidMemberIds,
          ...equb.confirmedPayerIds,
          ...equb.unconfirmedPayerIds,
          ...equb.rejectedPayerIds,
          if (equb.creatorId != null) equb.creatorId!,
          if (equb.currentHighestBidderId != null) equb.currentHighestBidderId!,
          if (equb.latestWinner != null) equb.latestWinner!.id,
        ];

        expect(referenced, everyElement(isIn(memberIds)), reason: path);
      }
    });

    test('resolving unpaid member ids returns real members', () {
      final equb = EqubDetail.fromJson(jsonFixture(equbDetailPaymentStage));

      expect(
        equb.membersByIds(equb.unpaidMemberIds).length,
        equb.unpaidMemberIds.length,
      );
    });

    test('an equb sends each of its members exactly once', () {
      for (final path in equbDetailByState.values) {
        final equb = EqubDetail.fromJson(jsonFixture(path));
        final ids = equb.members.map((m) => m.id).toList();

        expect(ids, hasLength(ids.toSet().length), reason: path);
      }
    });
  });
}
