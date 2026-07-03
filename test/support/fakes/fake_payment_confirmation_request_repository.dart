import 'package:equb_v3_frontend/models/payment_confirmation_request/payment_confirmation_request.dart';
import 'package:equb_v3_frontend/repositories/payment_confirmation_request_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../builders/payment_builders.dart';

class FakePaymentConfirmationRequestRepository extends Fake
    implements PaymentConfirmationRequestRepository {
  final List<String> calls = [];

  List<PaymentConfirmationRequest> requestsResult = const [];
  PaymentConfirmationRequest? createResult;
  PaymentConfirmationRequest? acceptResult;
  PaymentConfirmationRequest? rejectResult;

  Object? nextError;

  void _maybeThrow() {
    final error = nextError;
    if (error != null) {
      nextError = null;
      throw error;
    }
  }

  @override
  Future<PaymentConfirmationRequest> createPaymentConfirmationRequest(
      int equbId, int paymentMethodId, int round, String message) async {
    calls.add('create($equbId, $paymentMethodId, $round, $message)');
    _maybeThrow();
    return createResult ?? buildPaymentConfirmationRequest();
  }

  @override
  Future<List<PaymentConfirmationRequest>> getPaymentConfirmationRequests(
      int equbId, int round) async {
    calls.add('get($equbId, $round)');
    _maybeThrow();
    return requestsResult;
  }

  @override
  Future<PaymentConfirmationRequest> acceptPaymentConfirmationRequest(
      int paymentConfirmationRequestId) async {
    calls.add('accept($paymentConfirmationRequestId)');
    _maybeThrow();
    return acceptResult ??
        buildPaymentConfirmationRequest(
            id: paymentConfirmationRequestId, isAccepted: true);
  }

  @override
  Future<PaymentConfirmationRequest> rejectPaymentConfirmationRequest(
      int paymentConfirmationRequestId) async {
    calls.add('reject($paymentConfirmationRequestId)');
    _maybeThrow();
    return rejectResult ??
        buildPaymentConfirmationRequest(id: paymentConfirmationRequestId);
  }
}
