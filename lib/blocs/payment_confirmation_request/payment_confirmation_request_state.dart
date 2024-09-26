import 'package:equatable/equatable.dart';
import 'package:equb_v3_frontend/models/payment_confirmation_request/payment_confirmation_request.dart';

enum PaymentConfirmationRequestStatus { initial, loading, success, failure }
class PaymentConfirmationRequestState extends Equatable {
  const PaymentConfirmationRequestState({
    this.paymentConfirmationRequests = const [],
    this.selectedPaymentConfirmationRequest,
    this.status = PaymentConfirmationRequestStatus.initial,
    this.equbId,
    this.error,
  });

  final PaymentConfirmationRequestStatus status;
  final List<PaymentConfirmationRequest> paymentConfirmationRequests;
  final PaymentConfirmationRequest? selectedPaymentConfirmationRequest;
  final int? equbId;
  final String? error;

  @override
  List<Object?> get props => [status, paymentConfirmationRequests, selectedPaymentConfirmationRequest, equbId, error];

  PaymentConfirmationRequestState copyWith({
    PaymentConfirmationRequestStatus? status,
    List<PaymentConfirmationRequest>? paymentConfirmationRequests,
    PaymentConfirmationRequest? selectedPaymentConfirmationRequest,
    int? equbId,
    String? error,
  }) {
    return PaymentConfirmationRequestState(
      status: status ?? this.status,
      paymentConfirmationRequests: paymentConfirmationRequests ?? this.paymentConfirmationRequests,
      selectedPaymentConfirmationRequest: selectedPaymentConfirmationRequest ?? this.selectedPaymentConfirmationRequest,
      equbId: equbId ?? this.equbId,
      error: error ?? this.error,
    );
  }
}