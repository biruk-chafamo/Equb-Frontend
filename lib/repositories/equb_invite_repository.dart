import 'package:equb_v3_frontend/models/equb_invite/equb_invite.dart';
import 'package:equb_v3_frontend/services/equb_invite_service.dart';

class EqubInviteRepository {
  final EqubInviteService equbInviteService;

  EqubInviteRepository({required this.equbInviteService});

  Future<EqubInvite> createEqubInvite(
    int receiverId,
    int equbId,
  ) async {
    final equbInviteJson = await equbInviteService.createEqubInvite(
      receiverId,
      equbId,
    );

    return EqubInvite.fromJson(equbInviteJson);
  }

  Future<List<EqubInvite>> getReceivedEqubInvites() async {
    final equbInviteJsons = await equbInviteService.getReceivedEqubInvites();

    return equbInviteJsons
        .map(
          (dynamic item) => EqubInvite.fromJson(item),
        )
        .toList();
  }

  Future<List<EqubInvite>> getInvitesToEqub(int equbId) async {
    final equbInviteJsons = await equbInviteService.getInvitesToEqub(equbId);

    return equbInviteJsons
        .map(
          (dynamic item) => EqubInvite.fromJson(item),
        )
        .toList();
  }

  Future<List<EqubInvite>> getSentEqubInvites() async {
    final equbInviteJsons = await equbInviteService.getReceivedEqubInvites();

    return equbInviteJsons
        .map(
          (dynamic item) => EqubInvite.fromJson(item),
        )
        .toList();
  }

  Future<EqubInvite> acceptEqubInvite(int equbInviteId) async {
    final equbInviteJson = await equbInviteService.acceptEqubInvite(
      equbInviteId,
    );

    return EqubInvite.fromJson(equbInviteJson);
  }

  Future<EqubInvite> expireEqubInvite(int equbInviteId) async {
    final equbInviteJson = await equbInviteService.expireEqubInvite(
      equbInviteId,
    );

    return EqubInvite.fromJson(equbInviteJson);
  }
}
