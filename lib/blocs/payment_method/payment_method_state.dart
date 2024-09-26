part of 'payment_method_bloc.dart';

enum PaymentMethodStatus { initial, loading, success, failure }

class PaymentMethodState extends Equatable {
  const PaymentMethodState({
    this.paymentMethods = const [],
    this.selectedPaymentMethod,
    this.status = PaymentMethodStatus.initial,
    this.services = const [],
    this.error,
  });

  final PaymentMethodStatus status;
  final List<PaymentMethod> paymentMethods;
  final PaymentMethod? selectedPaymentMethod;
  final List<String> services;
  final String? error;

  @override
  List<Object?> get props =>
      [status, paymentMethods, selectedPaymentMethod, error];

  PaymentMethodState copyWith({
    PaymentMethodStatus? status,
    List<PaymentMethod>? paymentMethods,
    PaymentMethod? selectedPaymentMethod,
    List<String>? services,
    String? error,
  }) {
    return PaymentMethodState(
      status: status ?? this.status,
      paymentMethods:
          paymentMethods ?? this.paymentMethods,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      services: services ?? this.services,
      error: error ?? this.error,
    );
  }
}
