import 'dart:async';

import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_state.dart';
import 'package:equb_v3_frontend/blocs/equb_invite/equb_invite_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_overview/equbs_overview_event.dart';
import 'package:equb_v3_frontend/blocs/equb_overview/equbs_overview_state.dart';
import 'package:equb_v3_frontend/repositories/equb_repository.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EqubsOverviewBloc extends Bloc<EqubsOverviewEvent, EqubsOverviewState> {
  final EqubRepository equbRepository;
  final EqubBloc equbBloc;
  final EqubInviteBloc equbInviteBloc;
  late StreamSubscription equbBlocSubscription;
  late StreamSubscription equbInviteBlocSubscription;

  EqubsOverviewBloc({
    required this.equbRepository,
    required this.equbBloc,
    required this.equbInviteBloc,
  }) : super(const EqubsOverviewState()) {
    on<FetchEqubs>(_onFetchEqubsRequested);
    on<FetchFocusedUserEqubs>(_onFetchFocusedUserEqubsRequested);

    // update pending equb list whenever a new equb is created
    equbBlocSubscription = equbBloc.stream.listen(
      (equbDetailState) {
        if (equbDetailState.status == EqubDetailStatus.equbCreated &&
            state.type == EqubType.pending) {
          add(const FetchEqubs(EqubType.pending));
        }
      },
    );

    // update equbs overview list based on creation or acceptance of equb invites
    equbInviteBlocSubscription = equbInviteBloc.stream.listen(
      (equbInviteState) {
        if (equbInviteState.status == EqubInviteStatus.success) {
          if (state.type == EqubType.invites) {
            add(const FetchEqubs(EqubType.invites));
          } else if (state.type == EqubType.pending) {
            add(const FetchEqubs(EqubType.pending));
          } else if (state.type == EqubType.active) {
            add(const FetchEqubs(EqubType.active));
          }
        }
      },
    );
  }

  @override
  Future<void> close() {
    // Cancel the subscription when the bloc is closed
    equbBlocSubscription.cancel();
    equbInviteBlocSubscription.cancel();
    return super.close();
  }

  void _onFetchEqubsRequested(
      FetchEqubs event, Emitter<EqubsOverviewState> emit) async {
    emit(state.copyWith(status: EqubsOverviewStatus.loading, type: event.type));
    final equbsOverview = await equbRepository.getEqubs(event.type);
    emit(state.copyWith(
        status: EqubsOverviewStatus.success,
        equbsOverview: equbsOverview,
        type: event.type));
  }

  void _onFetchFocusedUserEqubsRequested(
      FetchFocusedUserEqubs event, Emitter<EqubsOverviewState> emit) async {
    emit(state.copyWith(status: EqubsOverviewStatus.loading));
    final equbsOverview =
        await equbRepository.getFocusedUserEqubs(event.userId);
    emit(state.copyWith(
      status: EqubsOverviewStatus.success,
      focusedUserEqubsOverview: equbsOverview,
    ));
  }
}
