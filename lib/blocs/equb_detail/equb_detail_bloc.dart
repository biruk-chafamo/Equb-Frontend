import 'dart:async';
import 'dart:convert';

import 'package:equb_v3_frontend/blocs/common/guarded_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_event.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_state.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_bloc.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_state.dart';
import 'package:equb_v3_frontend/repositories/equb_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class EqubBloc extends Bloc<EqubDetailEvent, EqubDetailState>
    with GuardedBloc<EqubDetailEvent, EqubDetailState> {
  final EqubRepository equbRepository;
  final PaymentConfirmationRequestBloc paymentBloc;
  late StreamSubscription paymentBlocSubscription;
  StreamSubscription? equbChannelSubscription;
  WebSocketChannel? _equbWsChannel;

  EqubBloc({
    required this.equbRepository,
    required this.paymentBloc,
  }) : super(const EqubDetailState()) {
    on<FetchEqubDetail>(
        guarded(_onFetchEqubDetailRequested, onFailure: _failure));
    on<StartEqubWsChannel>(guarded(_onStartEqubWsChannel, onFailure: _failure));
    on<EqubWsChannelClosed>(_onEqubWsChannelClosed);
    on<PlaceBid>(guarded(_onPlaceBidRequested, onFailure: _failure));
    on<CreateEqub>(guarded(_onCreateEqubRequested, onFailure: _createFailure));

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
    equbChannelSubscription?.cancel();
    return super.close();
  }

  EqubDetailState _failure(String message, Object? _) =>
      state.copyWith(status: EqubDetailStatus.failure, error: message);

  EqubDetailState _createFailure(String message, Object? details) =>
      state.copyWith(
        status: EqubDetailStatus.failure,
        error: message,
        parameterErrorJSON: details,
      );

  Future<void> _onCreateEqubRequested(
      CreateEqub event, Emitter<EqubDetailState> emit) async {
    emit(state.copyWith(status: EqubDetailStatus.loading, clearError: true));
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
  }

  Future<void> _onPlaceBidRequested(
      PlaceBid event, Emitter<EqubDetailState> emit) async {
    emit(state.copyWith(status: EqubDetailStatus.loading, clearError: true));
    final equbDetail =
        await equbRepository.palceBid(event.equbId, event.bidAmount);
    emit(state.copyWith(
        status: EqubDetailStatus.success, equbDetail: equbDetail));
  }

  Future<void> _onFetchEqubDetailRequested(
      FetchEqubDetail event, Emitter<EqubDetailState> emit) async {
    emit(state.copyWith(status: EqubDetailStatus.loading, clearError: true));
    final equbDetail = await equbRepository.getEqubDetail(event.equbId);

    if (!state.equbWsChannelStarted) {
      await _startEqubWsChannel(emit);
    }
    // Re-subscribe on every visit, not just the first ever connection:
    // the socket's initial connect-time snapshot misses equbs joined later
    // in the session, so this equb might not be in it yet.
    _equbWsChannel?.sink.add(jsonEncode({'equb_id': event.equbId}));

    emit(state.copyWith(
        status: EqubDetailStatus.success, equbDetail: equbDetail));
  }

  Future<void> _onStartEqubWsChannel(
      StartEqubWsChannel event, Emitter<EqubDetailState> emit) async {
    await _startEqubWsChannel(emit);
  }

  Future<void> _startEqubWsChannel(Emitter<EqubDetailState> emit) async {
    if (state.equbWsChannelStarted) return;

    _equbWsChannel = await equbRepository.startEqubWsChannel();

    equbChannelSubscription = _equbWsChannel!.stream.listen(
      (snapshot) {
        final data = jsonDecode(snapshot) as Map<String, dynamic>;
        final equbId = data['equb_id'];
        if (equbId == null) return;

        final pushedId =
            equbId is int ? equbId : int.tryParse(equbId.toString());

        // The socket carries updates for every equb the user belongs to, not
        // just the one on screen. Refetching another would replace the equb
        // they are looking at.
        if (pushedId == null || pushedId != state.equbDetail?.id) return;

        add(FetchEqubDetail(pushedId));
      },
      onDone: () => add(const EqubWsChannelClosed()),
    );

    emit(state.copyWith(equbWsChannelStarted: true));
  }

  void _onEqubWsChannelClosed(
      EqubWsChannelClosed event, Emitter<EqubDetailState> emit) {
    equbChannelSubscription?.cancel();
    equbChannelSubscription = null;
    _equbWsChannel = null;
    emit(state.copyWith(equbWsChannelStarted: false));
  }
}
