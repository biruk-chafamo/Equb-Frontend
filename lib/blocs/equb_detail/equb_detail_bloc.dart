import 'dart:async';

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

  EqubBloc({
    required this.equbRepository,
    required this.paymentBloc,
  }) : super(const EqubDetailState()) {
    on<FetchEqubDetail>(_onFetchEqubDetailRequested);
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
    return super.close();
  }

  void _onCreateEqubRequested(
      CreateEqub event, Emitter<EqubDetailState> emit) async {
    emit(const EqubDetailState(status: EqubDetailStatus.loading));
    final equbDetail = await equbRepository.createEqub(event.equb);
    // equb created state is only used to reload pending 
    // equbs overview screen with newly created equb   
    emit(
      EqubDetailState(
        status: EqubDetailStatus.equbCreated,
        equbDetail: equbDetail,
      ),
    );
    emit(
      EqubDetailState(
        status: EqubDetailStatus.success,
        equbDetail: equbDetail,
      ),
    );
  }

  void _onPlaceBidRequested(
      PlaceBid event, Emitter<EqubDetailState> emit) async {
    emit(const EqubDetailState(status: EqubDetailStatus.loading));
    final equbDetail =
        await equbRepository.palceBid(event.equbId, event.bidAmount);
    emit(EqubDetailState(
        status: EqubDetailStatus.success, equbDetail: equbDetail));
  }

  void _onFetchEqubDetailRequested(
      FetchEqubDetail event, Emitter<EqubDetailState> emit) async {
    emit(const EqubDetailState(status: EqubDetailStatus.loading));
    final equbDetail = await equbRepository.getEqubDetail(event.equbId);
    emit(EqubDetailState(
        status: EqubDetailStatus.success, equbDetail: equbDetail));
  }
}
