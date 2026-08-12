import 'package:equb_v3_frontend/network/dio_error_message.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/fixture_reader.dart';
import 'fixture_paths.dart';

void main() {
  group('envelopes', () {
    test('list endpoints return bare arrays', () {
      for (final name in bareArrayFixtures) {
        expect(jsonListFixture(name), isA<List<dynamic>>(), reason: name);
      }
    });

    test('the api index covers every endpoint the app calls', () {
      final index = jsonFixture(apiIndex);

      expect(index.length, greaterThanOrEqualTo(20));
      for (final entry in index.values) {
        expect((entry as Map<String, dynamic>)['status'], isA<int>());
      }
    });

    test('only user search paginates', () {
      final index = jsonFixture(apiIndex);

      final paginated = index.entries.where((e) {
        final keys = (e.value as Map<String, dynamic>)['keys'];
        return keys is List && keys.contains('results');
      }).map((e) => e.key);

      expect(paginated, hasLength(1));
      expect(paginated.first, contains('/users/search/'));
    });

    test('the payment methods by-user route does not exist', () {
      final index = jsonFixture(apiIndex);
      final entry = index.entries
          .firstWhere((e) => e.key.contains('/paymentmethods/by-user/'));

      expect((entry.value as Map<String, dynamic>)['status'], 404);
    });
  });

  group('auth', () {
    test('a token pair carries both tokens', () {
      final tokens = jsonFixture(authToken);

      expect(tokens.keys, containsAll(<String>['access', 'refresh']));
    });

    test('a refresh returns only a new access token', () {
      final refreshed = jsonFixture(authRefresh);

      expect(refreshed.keys, contains('access'));
      expect(refreshed.keys, isNot(contains('refresh')));
    });
  });

  group('errors', () {
    Map<String, dynamic> envelope(String name) =>
        jsonFixture(errorEnvelopes)[name] as Map<String, dynamic>;

    test('a bad login is a 401 with a detail key', () {
      final login = envelope('login_401');

      expect(login['status'], 401);
      expect((login['body'] as Map<String, dynamic>)['detail'], isA<String>());
    });

    test('a rejected bid is a 400 with per-field messages', () {
      final bid = envelope('bid_final_round_400');
      final body = bid['body'] as Map<String, dynamic>;

      expect(bid['status'], 400);
      expect(body['equb'], isA<List<dynamic>>());
      expect((body['equb'] as List<dynamic>).first, isA<String>());
    });

    test('a missing query parameter is a 400 with a detail key', () {
      final missing = envelope('missing_param_400');

      expect(missing['status'], 400);
      expect(
          (missing['body'] as Map<String, dynamic>)['detail'], isA<String>());
    });

    test('every captured envelope yields a readable message', () {
      for (final name in [
        'login_401',
        'bid_final_round_400',
        'missing_param_400',
        'not_found_404',
      ]) {
        final body = envelope(name)['body'];
        final message = describeDioError(_asDioLike(body));

        expect(message, isNotEmpty, reason: name);
      }
    });
  });
}

/// `describeDioError` walks a decoded response body, so the envelopes can be
/// checked without reconstructing a DioException around each one.
Object _asDioLike(Object? body) => body ?? 'unknown';
