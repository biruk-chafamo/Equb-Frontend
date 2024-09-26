part of 'equb_invite_bloc.dart';

sealed class EqubInviteEvent extends Equatable {
  const EqubInviteEvent();

  @override
  List<Object> get props => [];
}

class FetchReceivedEqubInvites extends EqubInviteEvent {
  const FetchReceivedEqubInvites();

  @override
  List<Object> get props => [];
}

class CreateEqubInvite extends EqubInviteEvent {
  final EqubDetail equb;
  final int receiverId;

  const CreateEqubInvite(this.receiverId, this.equb);

  @override
  List<Object> get props => [equb, receiverId];
}

class AcceptEqubInvite extends EqubInviteEvent {
  final int equbInviteId;

  const AcceptEqubInvite(
    this.equbInviteId,
  );

  @override
  List<Object> get props => [equbInviteId];
}

class ExpireEqubInvite extends EqubInviteEvent {
  final int equbInviteId;

  const ExpireEqubInvite(
    this.equbInviteId,
  );

  @override
  List<Object> get props => [equbInviteId];
}

class FetchEqubInvitesToEqub extends EqubInviteEvent {
  final EqubDetail equb;

  const FetchEqubInvitesToEqub(this.equb);

  @override
  List<Object> get props => [equb];
}

class FetchUsersByName extends EqubInviteEvent {
  final String name;

  const FetchUsersByName(this.name);

  @override
  List<Object> get props => [name];
}
