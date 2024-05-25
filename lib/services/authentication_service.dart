import 'dart:convert';
import 'package:equb_v3_frontend/models/authentication/user.dart';
import 'package:equb_v3_frontend/repositories/example_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationService {
  final String baseUrl;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  AuthenticationService({required this.baseUrl});

  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api-auth/token/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final accessToken = json['access'];
      final refreshToken = json['refresh'];

      // Store tokens
      await secureStorage.write(key: 'accessToken', value: accessToken);
      await secureStorage.write(key: 'refreshToken', value: refreshToken);
      // Fetch user profile
      final currentUser = await getUserProfile(accessToken);
      return currentUser;
    } else {
      return thisUser;
      // throw Exception('Failed to login');
    }
  }

  Future<User> getUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/currentuser'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final currentUser = User.fromJson(json);
      return currentUser;
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  Future<void> logout(String token) async {
    // Clear tokens from secure storage
    await secureStorage.delete(key: 'accessToken');
    await secureStorage.delete(key: 'refreshToken');
  }
}
