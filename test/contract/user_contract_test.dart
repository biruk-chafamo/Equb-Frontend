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
}
