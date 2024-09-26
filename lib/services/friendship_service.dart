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
    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Failed to send friend request');
    }
  }

  Future<Map<String, dynamic>> acceptFriendRequest(int friendRequestId) async {
    final response = await dio.put(
      '$baseUrl/friendrequests/$friendRequestId/',
      data: {
        'is_accepted': 'true',
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to accept friend request');
    }
  }

  Future<List<dynamic>> fetchFriends() async {
    final response = await dio.get(
      '$baseUrl/users/friends/',
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to accept friend request');
    }
  }

  Future<List<dynamic>> fetchSentFriendRequests() async {
    final response = await dio.get(
      '$baseUrl/friendrequests/sent/',
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to fetch sent friend requests');
    }
  }

  Future<List<dynamic>> fetchReceivedFriendRequests() async {
    final response = await dio.get(
      '$baseUrl/friendrequests/received/',
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to fetch received friend requests');
    }
  }
}
