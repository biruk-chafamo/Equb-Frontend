import 'package:equatable/equatable.dart';
import 'package:equb_v3_frontend/models/payment_method/payment_method.dart';
import 'package:equb_v3_frontend/repositories/payment_method_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'payment_method_event.dart';
part 'payment_method_state.dart';

class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState> {
  final PaymentMethodRepository paymentMethodRepository;
  PaymentMethodBloc({required this.paymentMethodRepository})
      : super(const PaymentMethodState()) {
    on<FetchAvailableServices>(_onFetchAvailableServices);
    on<CreatePaymentMethod>(_onCreatePaymentMethod);
    on<FetchPaymentMethods>(_onFetchPaymentMethods);
  }

  void _onFetchPaymentMethods(
      FetchPaymentMethods event, Emitter<PaymentMethodState> emit) async {
    emit(state.copyWith(
      status: PaymentMethodStatus.loading,
    ));
    final paymentMethods = await paymentMethodRepository.getPaymentMethods();
    emit(state.copyWith(
      status: PaymentMethodStatus.success,
      paymentMethods: paymentMethods,
    ));
  }
  
  void _onFetchAvailableServices(
      FetchAvailableServices event, Emitter<PaymentMethodState> emit) async {
    emit(state.copyWith(
      status: PaymentMethodStatus.loading,
    ));
    final services = await paymentMethodRepository.getServices();
    emit(state.copyWith(
      status: PaymentMethodStatus.success,
      services: services,
    ));
  }

  void _onCreatePaymentMethod(
      CreatePaymentMethod event, Emitter<PaymentMethodState> emit) async {
    emit(state.copyWith(
      status: PaymentMethodStatus.loading,
    ));
    final paymentMethod = await paymentMethodRepository.createPaymentMethod(
      event.service,
      event.detail,
    );
    emit(state.copyWith(
      status: PaymentMethodStatus.success,
      selectedPaymentMethod: paymentMethod,
      paymentMethods: [...state.paymentMethods, paymentMethod],
    ));
  }
}
