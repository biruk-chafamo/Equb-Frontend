import 'dart:convert';

import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  AuthService({required this.baseUrl});

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api-auth/token/'),
      body: jsonEncode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> refreshToken(String refresh) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api-auth/token/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refresh}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to refresh token');
    }
  }

  Future<Map<String, dynamic>> getCurrentUserProfile(String access) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/currentuser/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access'
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  Future<void> signup(UserDTO user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/'),
      body: jsonEncode(user.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201) {
      throw json.decode(response.body);
    }
  }

  // reset password
  Future<void> checkEmailExists(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api-auth/password_reset/'),
      body: jsonEncode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to reset password');
    }
  }

  Future<void> resetPassword(String token, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api-auth/password_reset/confirm/'),
      body: jsonEncode({'token': token, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw json.decode(response.body);
    }
  }
}
