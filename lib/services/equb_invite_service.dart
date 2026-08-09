import 'package:dio/dio.dart';

class EqubInviteService {
  final String baseUrl;
  final Dio dio;

  EqubInviteService({required this.baseUrl, required this.dio});

  Future<Map<String, dynamic>> createEqubInvite(
    int receiverId,
    int equbId,
  ) async {
    final response = await dio.post(
      '$baseUrl/equbinviterequests/',
      data: {
        'equb': '$baseUrl/equbs/$equbId/',
        'receiver': '$baseUrl/users/$receiverId/',
      },
      options: Options(
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ),
    );
    return response.data;
  }

  Future<List<dynamic>> getInvitesToEqub(int equbId) async {
    final response = await dio.get(
      '$baseUrl/equbinviterequests/by-equb/?equb=$equbId',
    );
    return response.data;
  }

  Future<List<dynamic>> getReceivedEqubInvites() async {
    final response = await dio.get(
      '$baseUrl/equbinviterequests/received/',
    );
    return response.data;
  }

  Future<List<dynamic>> getSentEqubInvites() async {
    final response = await dio.get(
      '$baseUrl/equbinviterequests/sent/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>> acceptEqubInvite(int equbInviteId) async {
    final response = await dio.put(
      '$baseUrl/equbinviterequests/$equbInviteId/',
      data: {
        'is_accepted': 'true',
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> expireEqubInvite(int equbInviteId) async {
    final response = await dio.put(
      '$baseUrl/equbinviterequests/$equbInviteId/',
      data: {
        'is_rejected': 'true',
      },
    );
    return response.data;
  }
}
