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
    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception(
          'Failed to create Equb invite request. Please try again later');
    }
  }

  Future<List<dynamic>> getInvitesToEqub(int equbId) async {
    final response = await dio.get(
      '$baseUrl/equbinviterequests/by-equb/?equb=$equbId',
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load Equb invites for equb $equbId');
    }
  }

  Future<List<dynamic>> getReceivedEqubInvites() async {
    final response = await dio.get(
      '$baseUrl/equbinviterequests/received',
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load received Equb invites');
    }
  }

  Future<List<dynamic>> getSentEqubInvites() async {
    final response = await dio.get(
      '$baseUrl/equbinviterequests/sent',
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load sent Equb invites');
    }
  }

  Future<Map<String, dynamic>> acceptEqubInvite(int equbInviteId) async {
    final response = await dio.put(
      '$baseUrl/equbinviterequests/$equbInviteId/',
      data: {
        'is_accepted': 'true',
      },
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to accept Equb invite');
    }
  }

  Future<Map<String, dynamic>> expireEqubInvite(int equbInviteId) async {
    final response = await dio.put(
      '$baseUrl/equbinviterequests/$equbInviteId/',
      data: {
        'is_rejected': 'true',
      },
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to expire Equb invite');
    }
  }
}
