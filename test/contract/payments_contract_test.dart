import 'package:equb_v3_frontend/models/payment_confirmation_request/payment_confirmation_request.dart';
import 'package:equb_v3_frontend/models/payment_method/payment_method.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/fixture_reader.dart';
import 'fixture_paths.dart';

void main() {
  group('payment methods', () {
    test('parse', () {
      final methods = jsonListFixture(paymentMethods)
          .cast<Map<String, dynamic>>()
          .map(PaymentMethod.fromJson)
          .toList();

      expect(methods, isNotEmpty);
      expect(methods.every((m) => m.service.isNotEmpty), isTrue);
    });

    test('every service the backend offers has a logo asset', () {
      final services = jsonListFixture(paymentServices).cast<String>();

      expect(services, isNotEmpty);
      for (final service in services) {
        expect(paymentMethodLogoPaths, contains(service));
      }
    });

    test('every offered service is usable as a payment method service', () {
      final services = jsonListFixture(paymentServices).cast<String>();

      expect(services, contains('Cash'));
      expect(services.toSet(), hasLength(services.length));
    });
  });

  group('payment confirmation requests', () {
    test('parse', () {
      final requests = jsonListFixture(paymentConfirmationRequests)
          .cast<Map<String, dynamic>>()
          .map(PaymentConfirmationRequest.fromJson)
          .toList();

      expect(requests, isNotEmpty);
      for (final request in requests) {
        expect(request.round, isPositive);
        expect(request.sender.username, isNotEmpty);
      }
    });

    test('sender is nested while equb and receiver are hyperlinks', () {
      final json = jsonListFixture(paymentConfirmationRequests).first
          as Map<String, dynamic>;

      expect(json['sender'], isA<Map<String, dynamic>>());
      expect(json['equb'], isA<String>());
      expect(json['receiver'], isA<String>());
    });

    test('a payment method arrives with the id the model requires', () {
      for (final item in jsonListFixture(paymentConfirmationRequests)
          .cast<Map<String, dynamic>>()) {
        final method = item['payment_method'] as Map<String, dynamic>;

        expect(method['id'], isA<int>());
        expect(method['service'], isA<String>());
      }
    });

    test('amount is not exposed to the client at all', () {
      final json = jsonListFixture(paymentConfirmationRequests).first
          as Map<String, dynamic>;

      expect(json.keys, isNot(contains('amount')));
    });
  });

  group('bids', () {
    test('amount is a string here but a number on an equb', () {
      final bid = jsonListFixture(bids).first as Map<String, dynamic>;
      final equb = jsonFixture(equbDetailActiveBid);

      expect(bid['amount'], isA<String>());
      expect(double.parse(bid['amount'] as String), inInclusiveRange(0.0, 1.0));
      expect(equb['current_highest_bid'], isA<num>());
      expect(equb['current_highest_bid'], isNot(isA<String>()));
    });

    test('expose only amount, equb and identity', () {
      final bid = jsonListFixture(bids).first as Map<String, dynamic>;

      expect(bid.keys, containsAll(<String>['id', 'url', 'amount', 'equb']));
      expect(bid.keys, hasLength(4));
    });

    test('do not tell the client which round they belong to', () {
      // Bid.Meta orders by -round, but round is absent from the serializer, so
      // the ordering is not something a client can reconstruct or rely on.
      for (final bid in jsonListFixture(bids).cast<Map<String, dynamic>>()) {
        expect(bid.keys, isNot(contains('round')));
        expect(bid.keys, isNot(contains('user')));
      }
    });

    test('every bid points at an equb by hyperlink', () {
      for (final bid in jsonListFixture(bids).cast<Map<String, dynamic>>()) {
        expect(bid['equb'], isA<String>());
        expect(bid['equb'], contains('/equbs/'));
      }
    });
  });
}
