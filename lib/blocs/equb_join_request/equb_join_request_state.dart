part of 'equb_join_request_bloc.dart';

enum EqubJoinRequestStatus { initial, loading, success, failure }

class EqubJoinRequestState extends Equatable {
  const EqubJoinRequestState({
    this.status = EqubJoinRequestStatus.initial,
    this.joinRequests = const [],
    this.equbId,
    this.error,
  });

  final EqubJoinRequestStatus status;
  final List<EqubJoinRequest> joinRequests;
  final int? equbId;
  final String? error;

  List<EqubJoinRequest> forEqub(int equbId) =>
      joinRequests.where((request) => request.equbId == equbId).toList();

  @override
  List<Object?> get props => [status, joinRequests, equbId, error];

  EqubJoinRequestState copyWith({
    EqubJoinRequestStatus? status,
    List<EqubJoinRequest>? joinRequests,
    int? equbId,
    String? error,
    bool clearError = false,
  }) {
    return EqubJoinRequestState(
      status: status ?? this.status,
      joinRequests: joinRequests ?? this.joinRequests,
      equbId: equbId ?? this.equbId,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
