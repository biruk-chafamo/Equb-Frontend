import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_event.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_state.dart';
import 'package:equb_v3_frontend/repositories/payment_confirmation_request_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentConfirmationRequestBloc extends Bloc<
    PaymentConfirmationRequestEvent, PaymentConfirmationRequestState> {
  final PaymentConfirmationRequestRepository
      paymentConfirmationRequestRepository;

  PaymentConfirmationRequestBloc(
      {required this.paymentConfirmationRequestRepository})
      : super(const PaymentConfirmationRequestState()) {
    on<FetchPaymentConfirmationRequests>(
        _onFetchPaymentConfirmationRequestRequested);
    on<CreatePaymentConfirmationRequest>(_onCreatePaymentConfirmationRequest);
    on<AcceptPaymentConfirmationRequest>(_onAcceptPaymentConfirmationRequest);
    on<RejectPaymentConfirmationRequest>(_onRejectPaymentConfirmationRequest);
  }

  void _onFetchPaymentConfirmationRequestRequested(
      FetchPaymentConfirmationRequests event,
      Emitter<PaymentConfirmationRequestState> emit) async {
    emit(state.copyWith(status: PaymentConfirmationRequestStatus.loading));
    final paymentConfirmationRequests =
        await paymentConfirmationRequestRepository
            .getPaymentConfirmationRequests(
      event.equbId,
      event.round,
    );
    emit(PaymentConfirmationRequestState(
      status: PaymentConfirmationRequestStatus.success,
      paymentConfirmationRequests: paymentConfirmationRequests,
      equbId: event.equbId,
    ));
  }

  void _onCreatePaymentConfirmationRequest(
      CreatePaymentConfirmationRequest event,
      Emitter<PaymentConfirmationRequestState> emit) async {
    emit(state.copyWith(status: PaymentConfirmationRequestStatus.loading));
    final paymentConfirmationRequest =
        await paymentConfirmationRequestRepository
            .createPaymentConfirmationRequest(
      event.equbId,
      event.paymentMethodId,
      event.round,
      event.message,
    );
    emit(state.copyWith(
      status: PaymentConfirmationRequestStatus.success,
      paymentConfirmationRequests: [
        ...state.paymentConfirmationRequests,
        paymentConfirmationRequest,
      ],
      equbId: event.equbId,
    ));
  }

  void _onAcceptPaymentConfirmationRequest(
      AcceptPaymentConfirmationRequest event,
      Emitter<PaymentConfirmationRequestState> emit) async {
    final currentPaymentConfirmationRequest = state.paymentConfirmationRequests;
    final equbId = state.equbId;
    emit(state.copyWith(status: PaymentConfirmationRequestStatus.loading));
    await paymentConfirmationRequestRepository.acceptPaymentConfirmationRequest(
      event.paymentConfirmationRequestId,
    );
    final updatedPaymentConfirmationRequests =
        currentPaymentConfirmationRequest.map((paymentConfirmationRequest) {
      if (paymentConfirmationRequest.id == event.paymentConfirmationRequestId) {
        return paymentConfirmationRequest.copyWith(
          isAccepted: true,
        );
      }
      return paymentConfirmationRequest;
    }).toList();
    emit(state.copyWith(
      status: PaymentConfirmationRequestStatus.success,
      paymentConfirmationRequests: updatedPaymentConfirmationRequests,
      equbId: equbId,
    ));
  }

  void _onRejectPaymentConfirmationRequest(
      RejectPaymentConfirmationRequest event,
      Emitter<PaymentConfirmationRequestState> emit) async {
    final currentPaymentConfirmationRequest = state.paymentConfirmationRequests;
    final equbId = state.equbId;
    emit(state.copyWith(status: PaymentConfirmationRequestStatus.loading));
    await paymentConfirmationRequestRepository.rejectPaymentConfirmationRequest(
      event.paymentConfirmationRequestId,
    );
    final updatedPaymentConfirmationRequests = currentPaymentConfirmationRequest
        .where((paymentConfirmationRequest) =>
            paymentConfirmationRequest.id != event.paymentConfirmationRequestId)
        .toList();
    emit(state.copyWith(
      status: PaymentConfirmationRequestStatus.success,
      paymentConfirmationRequests: updatedPaymentConfirmationRequests,
      equbId: equbId,
    ));
  }
}
