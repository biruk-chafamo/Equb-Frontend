import 'package:equatable/equatable.dart';

sealed class PaymentConfirmationRequestEvent extends Equatable {
  const PaymentConfirmationRequestEvent();

  @override
  List<Object> get props => [];
}

class FetchPaymentConfirmationRequests extends PaymentConfirmationRequestEvent {
  final int equbId;
  final int round;

  const FetchPaymentConfirmationRequests(this.equbId, this.round);

  @override
  List<Object> get props => [equbId, round];
}

class CreatePaymentConfirmationRequest extends PaymentConfirmationRequestEvent {
  final int equbId;
  final int round;
  final int paymentMethodId;
  final String message;

  const CreatePaymentConfirmationRequest(
    this.equbId,
    this.round,
    this.paymentMethodId,
    this.message,
  );

  @override
  List<Object> get props => [equbId, round, paymentMethodId, message];
}

class AcceptPaymentConfirmationRequest extends PaymentConfirmationRequestEvent {
  final int paymentConfirmationRequestId;

  const AcceptPaymentConfirmationRequest(
    this.paymentConfirmationRequestId,
  );

  @override
  List<Object> get props => [paymentConfirmationRequestId];
}

class RejectPaymentConfirmationRequest extends PaymentConfirmationRequestEvent {
  final int paymentConfirmationRequestId;

  const RejectPaymentConfirmationRequest(
    this.paymentConfirmationRequestId,
  );

  @override
  List<Object> get props => [paymentConfirmationRequestId];
}