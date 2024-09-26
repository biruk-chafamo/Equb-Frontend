import 'package:equb_v3_frontend/models/payment_confirmation_request/payment_confirmation_request.dart';
import 'package:equb_v3_frontend/services/payment_confirmation_request_service.dart';

class PaymentConfirmationRequestRepository {
  final PaymentConfirmationRequestService paymentConfirmationRequestService;

  PaymentConfirmationRequestRepository(
      {required this.paymentConfirmationRequestService});

  Future<PaymentConfirmationRequest> createPaymentConfirmationRequest(
      int equbId, int paymentMethodId, int round, String message) async {
    final paymentConfirmationRequestJson =
        await paymentConfirmationRequestService
            .createPaymentConfirmationRequest(
      equbId,
      paymentMethodId,
      round,
      message,
    );

    return PaymentConfirmationRequest.fromJson(paymentConfirmationRequestJson);
  }

  Future<List<PaymentConfirmationRequest>> getPaymentConfirmationRequests(
      int equbId, int round) async {
    final paymentConfirmationRequestJsons =
        await paymentConfirmationRequestService.getPaymentConfirmationRequests(
      equbId,
      round,
    );

    return paymentConfirmationRequestJsons
        .map(
          (dynamic item) => PaymentConfirmationRequest.fromJson(item),
        )
        .toList();
  }

  Future<PaymentConfirmationRequest> acceptPaymentConfirmationRequest(
      int paymentConfirmationRequestId) async {
    final paymentConfirmationRequestJson =
        await paymentConfirmationRequestService
            .acceptPaymentConfirmationRequest(
      paymentConfirmationRequestId,
    );

    return PaymentConfirmationRequest.fromJson(paymentConfirmationRequestJson);
  }

  Future<PaymentConfirmationRequest> rejectPaymentConfirmationRequest(
      int paymentConfirmationRequestId) async {
    final paymentConfirmationRequestJson =
        await paymentConfirmationRequestService
            .rejectPaymentConfirmationRequest(
      paymentConfirmationRequestId,
    );

    return PaymentConfirmationRequest.fromJson(paymentConfirmationRequestJson);
  }
}
