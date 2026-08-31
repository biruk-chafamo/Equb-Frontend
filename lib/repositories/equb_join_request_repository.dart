import 'package:equb_v3_frontend/models/equb_join_request/equb_join_request.dart';
import 'package:equb_v3_frontend/services/equb_join_request_service.dart';

class EqubJoinRequestRepository {
  final EqubJoinRequestService equbJoinRequestService;

  EqubJoinRequestRepository({required this.equbJoinRequestService});

  Future<EqubJoinRequest> createJoinRequest(int equbId) async {
    final json = await equbJoinRequestService.createJoinRequest(equbId);

    return EqubJoinRequest.fromJson(json);
  }

  Future<List<EqubJoinRequest>> getJoinRequestsToEqub(int equbId) async {
    final jsons = await equbJoinRequestService.getJoinRequestsToEqub(equbId);

    return jsons
        .map(
          (dynamic item) => EqubJoinRequest.fromJson(item),
        )
        .toList();
  }

  Future<List<EqubJoinRequest>> getPendingJoinRequests() async {
    final jsons = await equbJoinRequestService.getPendingJoinRequests();

    return jsons
        .map(
          (dynamic item) => EqubJoinRequest.fromJson(item),
        )
        .toList();
  }

  Future<EqubJoinRequest> voteOnJoinRequest(
    int joinRequestId,
    bool approve,
  ) async {
    final json = await equbJoinRequestService.voteOnJoinRequest(
      joinRequestId,
      approve,
    );

    return EqubJoinRequest.fromJson(json);
  }
}
