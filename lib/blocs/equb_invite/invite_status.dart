import 'package:equb_v3_frontend/models/equb_invite/equb_invite.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/utils/constants.dart';

List<UserWithInviteStatus> deriveInviteStatuses({
  required List<User> users,
  required List<UserSummary> members,
  required List<EqubInvite> equbInvites,
}) {
  return users.map((user) {
    if (members.any((member) => member.id == user.id)) {
      return UserWithInviteStatus(
          user: user, inviteStatus: InviteStatus.member);
    }
    if (equbInvites.any((invite) => invite.receiver.id == user.id)) {
      return UserWithInviteStatus(
          user: user, inviteStatus: InviteStatus.invited);
    }
    return UserWithInviteStatus(user: user, inviteStatus: InviteStatus.none);
  }).toList();
}
