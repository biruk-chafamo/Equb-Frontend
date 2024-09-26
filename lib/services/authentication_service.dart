import 'package:dio/dio.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl;
  final Dio dio;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  AuthService({required this.baseUrl, required this.dio});

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await dio.post(
      '$baseUrl/api-auth/token/',
      data: {'username': username, 'password': password},
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    if (response.statusCode == 200) {
      final json = response.data;
      return json;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> refreshToken(String refresh) async {
    final response = await dio.post(
      '$baseUrl/api-auth/token/refresh/',
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
      data: {'refresh': refresh},
    );
    if (response.statusCode == 200) {
      final json = response.data;
      return json;
    } else {
      throw Exception('Failed to refresh token');
    }
  }

  Future<Map<String, dynamic>> getCurrentUserProfile(String access) async {
    final response = await dio.get(
      '$baseUrl/users/currentuser',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access'
        },
      ),
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  Future<void> signup(UserDTO user) async {
    final response = await dio.post(
      '$baseUrl/users/',
      data: user.toJson(),
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    if (response.statusCode == 201) {
      final json = response.data;
      return json;
    } else {
      throw Exception('Failed to signup');
    }
  }

  // reset password
  Future<void> checkEmailExists(String email) async {
    final response = await dio.post(
      '$baseUrl/api-auth/password_reset/',
      data: {'email': email},
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    if (response.statusCode == 200) {
      final json = response.data;
      return json;
    } else {
      throw Exception('Failed to reset password');
    }
  }

  Future<void> resetPassword(String token, String password) async {
    final response = await dio.post(
      '$baseUrl/api-auth/password_reset/confirm/',
      data: {'token': token, 'password': password},
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    if (response.statusCode == 200) {
      final json = response.data;
      return json;
    } else {
      throw Exception('Failed to reset password');
    }
  }
}
