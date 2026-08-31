import 'package:equatable/equatable.dart';
import 'package:equb_v3_frontend/blocs/common/guarded_bloc.dart';
import 'package:equb_v3_frontend/models/equb_join_request/equb_join_request.dart';
import 'package:equb_v3_frontend/repositories/equb_join_request_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'equb_join_request_event.dart';
part 'equb_join_request_state.dart';

class EqubJoinRequestBloc
    extends Bloc<EqubJoinRequestEvent, EqubJoinRequestState>
    with GuardedBloc<EqubJoinRequestEvent, EqubJoinRequestState> {
  final EqubJoinRequestRepository equbJoinRequestRepository;

  EqubJoinRequestBloc({required this.equbJoinRequestRepository})
      : super(const EqubJoinRequestState()) {
    on<FetchJoinRequestsToEqub>(
        guarded(_onFetchJoinRequestsToEqub, onFailure: _failure));
    on<FetchPendingJoinRequests>(
        guarded(_onFetchPendingJoinRequests, onFailure: _failure));
    on<SendJoinRequest>(guarded(_onSendJoinRequest, onFailure: _failure));
    on<VoteOnJoinRequest>(guarded(_onVoteOnJoinRequest, onFailure: _failure));
  }

  EqubJoinRequestState _failure(String message, Object? _) =>
      state.copyWith(status: EqubJoinRequestStatus.failure, error: message);

  Future<void> _onFetchJoinRequestsToEqub(
      FetchJoinRequestsToEqub event, Emitter<EqubJoinRequestState> emit) async {
    emit(state.copyWith(status: EqubJoinRequestStatus.loading));
    final joinRequests =
        await equbJoinRequestRepository.getJoinRequestsToEqub(event.equbId);
    emit(state.copyWith(
      status: EqubJoinRequestStatus.success,
      joinRequests: joinRequests,
      equbId: event.equbId,
      clearError: true,
    ));
  }

  Future<void> _onFetchPendingJoinRequests(FetchPendingJoinRequests event,
      Emitter<EqubJoinRequestState> emit) async {
    emit(state.copyWith(status: EqubJoinRequestStatus.loading));
    final joinRequests =
        await equbJoinRequestRepository.getPendingJoinRequests();
    emit(state.copyWith(
      status: EqubJoinRequestStatus.success,
      joinRequests: joinRequests,
      clearError: true,
    ));
  }

  Future<void> _onSendJoinRequest(
      SendJoinRequest event, Emitter<EqubJoinRequestState> emit) async {
    emit(state.copyWith(status: EqubJoinRequestStatus.loading));
    final joinRequest =
        await equbJoinRequestRepository.createJoinRequest(event.equbId);
    emit(state.copyWith(
      status: EqubJoinRequestStatus.success,
      joinRequests: [...state.joinRequests, joinRequest],
      clearError: true,
    ));
  }

  Future<void> _onVoteOnJoinRequest(
      VoteOnJoinRequest event, Emitter<EqubJoinRequestState> emit) async {
    emit(state.copyWith(status: EqubJoinRequestStatus.loading));
    final voted = await equbJoinRequestRepository.voteOnJoinRequest(
      event.joinRequestId,
      event.approve,
    );
    final remaining = state.joinRequests
        .map((request) => request.id == voted.id ? voted : request)
        .where((request) => !request.isDecided)
        .toList();
    emit(state.copyWith(
      status: EqubJoinRequestStatus.success,
      joinRequests: remaining,
      clearError: true,
    ));
  }
}
