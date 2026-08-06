import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_event.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_state.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_bloc.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_state.dart';
import 'package:equb_v3_frontend/repositories/equb_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EqubBloc extends Bloc<EqubDetailEvent, EqubDetailState> {
  final EqubRepository equbRepository;
  final PaymentConfirmationRequestBloc paymentBloc;
  late StreamSubscription paymentBlocSubscription;
  late StreamSubscription equbChannelSubscription;

  EqubBloc({
    required this.equbRepository,
    required this.paymentBloc,
  }) : super(const EqubDetailState()) {
    on<FetchEqubDetail>(_onFetchEqubDetailRequested);
    on<StartEqubWsChannel>(_onStartEqubWsChannel);
    on<PlaceBid>(_onPlaceBidRequested);
    on<CreateEqub>(_onCreateEqubRequested);

    paymentBlocSubscription = paymentBloc.stream.listen((paymentState) {
      if (paymentState.status == PaymentConfirmationRequestStatus.success) {
        add(FetchEqubDetail(paymentState.equbId!));
      }
    });
  }

  @override
  Future<void> close() {
    // Cancel the subscription when the bloc is closed
    paymentBlocSubscription.cancel();
    equbChannelSubscription.cancel();
    return super.close();
  }

  void _onCreateEqubRequested(
      CreateEqub event, Emitter<EqubDetailState> emit) async {
    emit(state.copyWith(status: EqubDetailStatus.loading));
    try {
      final equbDetail = await equbRepository.createEqub(event.equb);
      // equb created state is only used to reload pending
      // equbs overview screen with newly created equb
      emit(
        state.copyWith(
          status: EqubDetailStatus.equbCreated,
          equbDetail: equbDetail,
        ),
      );
      emit(
        state.copyWith(
          status: EqubDetailStatus.success,
        ),
      );
    } on DioException catch (error) {
      emit(
        state.copyWith(
          status: EqubDetailStatus.failure,
          parameterErrorJSON: error.error,
        ),
      );
    }
  }

  void _onPlaceBidRequested(
      PlaceBid event, Emitter<EqubDetailState> emit) async {
    emit(state.copyWith(status: EqubDetailStatus.loading));
    final equbDetail =
        await equbRepository.palceBid(event.equbId, event.bidAmount);
    emit(state.copyWith(
        status: EqubDetailStatus.success, equbDetail: equbDetail));
  }

  void _onFetchEqubDetailRequested(
      FetchEqubDetail event, Emitter<EqubDetailState> emit) async {
    emit(state.copyWith(status: EqubDetailStatus.loading));
    final equbDetail = await equbRepository.getEqubDetail(event.equbId);
    if (!state.equbWsChannelStarted) {
      add(StartEqubWsChannel());
    }
    emit(state.copyWith(
        status: EqubDetailStatus.success, equbDetail: equbDetail));
  }

  void _onStartEqubWsChannel(
      StartEqubWsChannel event, Emitter<EqubDetailState> emit) async {
    if (!state.equbWsChannelStarted) {
      emit(state.copyWith(status: EqubDetailStatus.loading));
      final equbWsChannel = await equbRepository.startEqubWsChannel();

      equbChannelSubscription = equbWsChannel.stream.listen(
        (snapshot) {
          final data = jsonDecode(snapshot) as Map<String, dynamic>;
          final equbId = data['equb_id'];

          if (equbId != null) {
            add(FetchEqubDetail(
              equbId is int ? equbId : int.parse(equbId.toString()),
            ));
          }
        },
        onDone: () {
          emit(state.copyWith(equbWsChannelStarted: false));
        },
      );

      emit(state.copyWith(
          status: EqubDetailStatus.success, equbWsChannelStarted: true));
    }
  }
}
