part of 'payment_method_bloc.dart';

sealed class PaymentMethodEvent extends Equatable {
  const PaymentMethodEvent();

  @override
  List<Object> get props => [];
}

class CreatePaymentMethod extends PaymentMethodEvent {
  final String service;
  final String detail;

  const CreatePaymentMethod({required this.service, required this.detail});

  @override
  List<Object> get props => [service, detail];
}

class FetchPaymentMethodsByUser extends PaymentMethodEvent {
  final int userId;

  const FetchPaymentMethodsByUser({required this.userId});

  @override
  List<Object> get props => [userId];
}

class FetchPaymentMethods extends PaymentMethodEvent {
  const FetchPaymentMethods();

  @override
  List<Object> get props => [];
}

class FetchAvailableServices extends PaymentMethodEvent {
  const FetchAvailableServices();
}
