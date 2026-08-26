import 'package:equb_v3_frontend/models/equb_join_request/equb_join_request.dart';
import 'package:equb_v3_frontend/repositories/equb_join_request_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../builders/equb_join_request_builder.dart';

class FakeEqubJoinRequestRepository extends Fake
    implements EqubJoinRequestRepository {
  final List<String> calls = [];

  List<EqubJoinRequest> joinRequestsToEqubResult = const [];
  List<EqubJoinRequest> pendingJoinRequestsResult = const [];
  EqubJoinRequest? createResult;
  EqubJoinRequest? voteResult;

  Object? nextError;

  void _maybeThrow() {
    final error = nextError;
    if (error != null) {
      nextError = null;
      throw error;
    }
  }

  @override
  Future<EqubJoinRequest> createJoinRequest(int equbId) async {
    calls.add('createJoinRequest($equbId)');
    _maybeThrow();
    return createResult ?? buildEqubJoinRequest(equbId: equbId);
  }

  @override
  Future<List<EqubJoinRequest>> getJoinRequestsToEqub(int equbId) async {
    calls.add('getJoinRequestsToEqub($equbId)');
    _maybeThrow();
    return joinRequestsToEqubResult;
  }

  @override
  Future<List<EqubJoinRequest>> getPendingJoinRequests() async {
    calls.add('getPendingJoinRequests()');
    _maybeThrow();
    return pendingJoinRequestsResult;
  }

  @override
  Future<EqubJoinRequest> voteOnJoinRequest(
      int joinRequestId, bool approve) async {
    calls.add('voteOnJoinRequest($joinRequestId, $approve)');
    _maybeThrow();
    return voteResult ??
        buildEqubJoinRequest(
          id: joinRequestId,
          currentUserVote: approve,
          approvals: approve ? 1 : 0,
          rejections: approve ? 0 : 1,
        );
  }
}
