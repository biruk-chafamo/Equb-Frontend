import 'package:equb_v3_frontend/models/equb_invite/equb_invite.dart';
import 'package:equb_v3_frontend/repositories/equb_invite_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../builders/equb_invite_builder.dart';

class FakeEqubInviteRepository extends Fake implements EqubInviteRepository {
  final List<String> calls = [];

  List<EqubInvite> receivedInvitesResult = const [];
  List<EqubInvite> invitesToEqubResult = const [];
  List<EqubInvite> sentInvitesResult = const [];
  EqubInvite? createResult;

  Object? nextError;

  void _maybeThrow() {
    final error = nextError;
    if (error != null) {
      nextError = null;
      throw error;
    }
  }

  @override
  Future<EqubInvite> createEqubInvite(int receiverId, int equbId) async {
    calls.add('createEqubInvite($receiverId, $equbId)');
    _maybeThrow();
    return createResult ?? buildEqubInvite();
  }

  @override
  Future<List<EqubInvite>> getReceivedEqubInvites() async {
    calls.add('getReceivedEqubInvites()');
    _maybeThrow();
    return receivedInvitesResult;
  }

  @override
  Future<List<EqubInvite>> getInvitesToEqub(int equbId) async {
    calls.add('getInvitesToEqub($equbId)');
    _maybeThrow();
    return invitesToEqubResult;
  }

  @override
  Future<List<EqubInvite>> getSentEqubInvites() async {
    calls.add('getSentEqubInvites()');
    _maybeThrow();
    return sentInvitesResult;
  }

  @override
  Future<EqubInvite> acceptEqubInvite(int equbInviteId) async {
    calls.add('acceptEqubInvite($equbInviteId)');
    _maybeThrow();
    return buildEqubInvite(id: equbInviteId, isAccepted: true);
  }

  @override
  Future<EqubInvite> expireEqubInvite(int equbInviteId) async {
    calls.add('expireEqubInvite($equbInviteId)');
    _maybeThrow();
    return buildEqubInvite(id: equbInviteId);
  }
}
