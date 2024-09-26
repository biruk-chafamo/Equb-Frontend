import 'package:equatable/equatable.dart';
import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/models/equb_invite/equb_invite.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/repositories/equb_invite_repository.dart';
import 'package:equb_v3_frontend/repositories/user_repository.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'equb_invite_event.dart';
part 'equb_invite_state.dart';

class EqubInviteBloc extends Bloc<EqubInviteEvent, EqubInviteState> {
  final EqubInviteRepository equbInviteRepository;
  final UserRepository userRepository;

  EqubInviteBloc(
      {required this.equbInviteRepository, required this.userRepository})
      : super(const EqubInviteState()) {
    on<FetchReceivedEqubInvites>(_onFetchReceivedEqubInviteRequested);
    on<FetchEqubInvitesToEqub>(_onFetchEqubInvitesToEqubRequested);
    on<CreateEqubInvite>(_onCreateEqubInvite);
    on<AcceptEqubInvite>(_onAcceptEqubInvite);
    on<ExpireEqubInvite>(_onExpireEqubInvite);
    on<FetchUsersByName>(_onFetchUsersByName);
  }

  void _onFetchEqubInvitesToEqubRequested(
      FetchEqubInvitesToEqub event, Emitter<EqubInviteState> emit) async {
    emit(const EqubInviteState(status: EqubInviteStatus.loading));
    final equbInvites = await equbInviteRepository.getInvitesToEqub(
      event.equb.id,
    );
    emit(EqubInviteState(
      status: EqubInviteStatus.success,
      equbInvites: equbInvites,
      equb: event.equb,
    ));
  }

  void _onFetchReceivedEqubInviteRequested(
      FetchReceivedEqubInvites event, Emitter<EqubInviteState> emit) async {
    emit(const EqubInviteState(status: EqubInviteStatus.loading));
    final equbInvites = await equbInviteRepository.getReceivedEqubInvites();
    emit(EqubInviteState(
      status: EqubInviteStatus.success,
      equbInvites: equbInvites,
    ));
  }

  void _onCreateEqubInvite(
      CreateEqubInvite event, Emitter<EqubInviteState> emit) async {
    emit(state.copyWith(status: EqubInviteStatus.loading));
    final equbInvite = await equbInviteRepository.createEqubInvite(
        event.receiverId, event.equb.id);
    emit(state.copyWith(
      status: EqubInviteStatus.success,
      equbInvites: [
        ...state.equbInvites,
        equbInvite,
      ],
      equb: event.equb,
      searchedUsers: state.searchedUsers
          .map(
            (userWithInviteStatus) =>
                userWithInviteStatus.user.id == event.receiverId
                    ? UserWithInviteStatus(
                        user: userWithInviteStatus.user,
                        inviteStatus: InviteStatus.invited)
                    : userWithInviteStatus,
          )
          .toList(),
    ));
  }

  void _onAcceptEqubInvite(
      AcceptEqubInvite event, Emitter<EqubInviteState> emit) async {
    final currentEqubInvite = state.equbInvites;
    final equb = state.equb;
    emit(const EqubInviteState(status: EqubInviteStatus.loading));
    // remove accepted equb invite from list
    await equbInviteRepository.acceptEqubInvite(event.equbInviteId);
    final updatedEqubInvites = currentEqubInvite
        .where((equbInvite) => equbInvite.id != event.equbInviteId)
        .toList();
    emit(state.copyWith(
      status: EqubInviteStatus.success,
      equbInvites: updatedEqubInvites,
      equb: equb,
    ));
  }

  void _onExpireEqubInvite(
      ExpireEqubInvite event, Emitter<EqubInviteState> emit) async {
    final currentEqubInvite = state.equbInvites;
    final equb = state.equb;
    emit(const EqubInviteState(status: EqubInviteStatus.loading));
    await equbInviteRepository.expireEqubInvite(
      event.equbInviteId,
    );

    final updatedEqubInvites = currentEqubInvite
        .where((equbInvite) => equbInvite.id != event.equbInviteId)
        .toList();
    emit(state.copyWith(
      status: EqubInviteStatus.success,
      equbInvites: updatedEqubInvites,
      equb: equb,
    ));
  }

  void _onFetchUsersByName(
      FetchUsersByName event, Emitter<EqubInviteState> emit) async {
    emit(state.copyWith(status: EqubInviteStatus.loading));

    final List<User> searchedUsers =
        await userRepository.getUsersByName(event.name);

    final members = state.equb == null ? [] : state.equb!.members;

    final usersWithInviteStatus = searchedUsers.map((user) {
      if (members.any((member) => member.id == user.id)) {
        return UserWithInviteStatus(
            user: user, inviteStatus: InviteStatus.member);
      } else if (state.equbInvites
          .any((invite) => invite.receiver.id == user.id)) {
        return UserWithInviteStatus(
            user: user, inviteStatus: InviteStatus.invited);
      } else {
        return UserWithInviteStatus(
            user: user, inviteStatus: InviteStatus.none);
      }
    }).toList();

    emit(
      state.copyWith(
        status: EqubInviteStatus.success,
        searchedUsers: usersWithInviteStatus,
      ),
    );
  }
}
