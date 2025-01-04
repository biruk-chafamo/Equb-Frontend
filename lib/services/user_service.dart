import 'package:dio/dio.dart';

class UserService {
  final String baseUrl;
  final Dio dio;

  const UserService({required this.baseUrl, required this.dio});

  Future<List<dynamic>> getUsersByName(String name) async {
    final response = await dio.get(
      '$baseUrl/users/search/?name=$name',
    );
    if (response.statusCode == 200) {
      return response.data['results'];
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<Map<String, dynamic>> getUser(int id) async {
    final response = await dio.get(
      '$baseUrl/users/$id/',
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<Map<String, dynamic>> sendFriendRequest(int id) async {
    final response = await dio.get(
      '$baseUrl/friendrequests/',
      data: {
        'receiver': '$baseUrl/$id',
      },
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to send friend request');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await dio.get(
      '$baseUrl/users/currentuser/',
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to fetch user');
    }
  }
}
