import 'package:equatable/equatable.dart';
import 'package:equb_v3_frontend/blocs/common/guarded_bloc.dart';
import 'package:equb_v3_frontend/models/payment_method/payment_method.dart';
import 'package:equb_v3_frontend/repositories/payment_method_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'payment_method_event.dart';
part 'payment_method_state.dart';

class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState>
    with GuardedBloc<PaymentMethodEvent, PaymentMethodState> {
  final PaymentMethodRepository paymentMethodRepository;
  PaymentMethodBloc({required this.paymentMethodRepository})
      : super(const PaymentMethodState()) {
    on<FetchAvailableServices>(
        guarded(_onFetchAvailableServices, onFailure: _failure));
    on<CreatePaymentMethod>(guarded(_onCreatePaymentMethod, onFailure: _failure));
    on<FetchPaymentMethods>(guarded(_onFetchPaymentMethods, onFailure: _failure));
    on<FetchPaymentMethodsByUser>(
        guarded(_onFetchPaymentMethodsByUser, onFailure: _failure));
  }

  PaymentMethodState _failure(String message, Object? _) =>
      state.copyWith(status: PaymentMethodStatus.failure, error: message);

  Future<void> _onFetchPaymentMethodsByUser(
      FetchPaymentMethodsByUser event, Emitter<PaymentMethodState> emit) async {
    emit(state.copyWith(
      status: PaymentMethodStatus.loading,
      clearError: true,
    ));
    final paymentMethods =
        await paymentMethodRepository.getPaymentMethodsByUser(event.userId);
    emit(state.copyWith(
      status: PaymentMethodStatus.success,
      paymentMethods: paymentMethods,
    ));
  }

  Future<void> _onFetchPaymentMethods(
      FetchPaymentMethods event, Emitter<PaymentMethodState> emit) async {
    emit(state.copyWith(
      status: PaymentMethodStatus.loading,
      clearError: true,
    ));
    final paymentMethods = await paymentMethodRepository.getPaymentMethods();
    emit(state.copyWith(
      status: PaymentMethodStatus.success,
      paymentMethods: paymentMethods,
    ));
  }

  Future<void> _onFetchAvailableServices(
      FetchAvailableServices event, Emitter<PaymentMethodState> emit) async {
    emit(state.copyWith(
      status: PaymentMethodStatus.loading,
      clearError: true,
    ));
    final services = await paymentMethodRepository.getServices();
    emit(state.copyWith(
      status: PaymentMethodStatus.success,
      services: services,
    ));
  }

  Future<void> _onCreatePaymentMethod(
      CreatePaymentMethod event, Emitter<PaymentMethodState> emit) async {
    emit(state.copyWith(
      status: PaymentMethodStatus.loading,
      clearError: true,
    ));
    final paymentMethod = await paymentMethodRepository.createPaymentMethod(
      event.service,
      event.detail,
    );
    final paymentMethods = [...state.paymentMethods, paymentMethod];

    emit(state.copyWith(
      status: PaymentMethodStatus.newMethodCreated,
      selectedPaymentMethod: paymentMethod,
      paymentMethods: paymentMethods,
    ));

    emit(state.copyWith(
      status: PaymentMethodStatus.success,
      selectedPaymentMethod: paymentMethod,
      paymentMethods: paymentMethods,
    ));
  }
}
