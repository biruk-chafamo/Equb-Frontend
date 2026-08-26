import 'package:dio/dio.dart';

class EqubJoinRequestService {
  final String baseUrl;
  final Dio dio;

  EqubJoinRequestService({required this.baseUrl, required this.dio});

  Future<Map<String, dynamic>> createJoinRequest(int equbId) async {
    final response = await dio.post(
      '$baseUrl/equbjoinrequests/',
      data: {'equb': '$baseUrl/equbs/$equbId/'},
      options: Options(
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ),
    );
    return response.data;
  }

  Future<List<dynamic>> getJoinRequestsToEqub(int equbId) async {
    final response = await dio.get(
      '$baseUrl/equbjoinrequests/by-equb/?equb=$equbId',
    );
    return response.data;
  }

  Future<List<dynamic>> getPendingJoinRequests() async {
    final response = await dio.get('$baseUrl/equbjoinrequests/pending/');
    return response.data;
  }

  Future<Map<String, dynamic>> voteOnJoinRequest(
    int joinRequestId,
    bool approve,
  ) async {
    final response = await dio.post(
      '$baseUrl/equbjoinrequests/$joinRequestId/vote/',
      data: {'approve': approve},
    );
    return response.data;
  }
}
