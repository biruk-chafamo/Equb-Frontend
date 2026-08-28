part of 'equb_join_request_bloc.dart';

sealed class EqubJoinRequestEvent extends Equatable {
  const EqubJoinRequestEvent();

  @override
  List<Object> get props => [];
}

class FetchJoinRequestsToEqub extends EqubJoinRequestEvent {
  final int equbId;

  const FetchJoinRequestsToEqub(this.equbId);

  @override
  List<Object> get props => [equbId];
}

class FetchPendingJoinRequests extends EqubJoinRequestEvent {
  const FetchPendingJoinRequests();
}

class SendJoinRequest extends EqubJoinRequestEvent {
  final int equbId;

  const SendJoinRequest(this.equbId);

  @override
  List<Object> get props => [equbId];
}

class VoteOnJoinRequest extends EqubJoinRequestEvent {
  final int joinRequestId;
  final bool approve;

  const VoteOnJoinRequest(this.joinRequestId, this.approve);

  @override
  List<Object> get props => [joinRequestId, approve];
}
