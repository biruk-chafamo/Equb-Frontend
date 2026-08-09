import 'package:dio/dio.dart';

class FriendshipService {
  final String baseUrl;
  final Dio dio;

  const FriendshipService({required this.baseUrl, required this.dio});

  Future<Map<String, dynamic>> sendFriendRequest(int receiverId) async {
    final response = await dio.post(
      '$baseUrl/friendrequests/',
      data: {
        'receiver': '$baseUrl/users/$receiverId/',
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> acceptFriendRequest(int friendRequestId) async {
    final response = await dio.put(
      '$baseUrl/friendrequests/$friendRequestId/',
      data: {
        'is_accepted': 'true',
      },
    );

    return response.data;
  }

  Future<List<dynamic>> fetchFriends() async {
    final response = await dio.get(
      '$baseUrl/users/friends/',
    );

    return response.data;
  }

  Future<List<dynamic>> fetchFocusedUserFriends(int userId) async {
    final response = await dio.get(
      '$baseUrl/users/friends/?id=$userId',
    );

    return response.data;
  }

  Future<List<dynamic>> fetchSentFriendRequests() async {
    final response = await dio.get(
      '$baseUrl/friendrequests/sent/',
    );

    return response.data;
  }

  Future<List<dynamic>> fetchReceivedFriendRequests() async {
    final response = await dio.get(
      '$baseUrl/friendrequests/received/',
    );

    return response.data;
  }
}
