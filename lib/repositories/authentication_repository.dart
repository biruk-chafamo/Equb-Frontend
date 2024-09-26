import 'dart:async';

import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:equb_v3_frontend/services/authentication_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthRepository {
  final AuthService authService;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  const AuthRepository({
    required this.authService,
  });

  Future<String?> get getAccessToken async {
    var access = await secureStorage.read(key: 'access');
    var refresh = await secureStorage.read(key: 'refresh');

    if (access != null && !tokenHasExpired(access)) {
      // Access token is still valid, return it
      return access;
    } else if (refresh != null && !tokenHasExpired(refresh)) {
      // Refresh the access token using the refresh token
      final json = await authService.refreshToken(refresh);
      await storeTokens(json['access'], refresh);
      return json['access'];
    } else {
      // Tokens are expired or not available, handle login outside this method
      return null;
    }
  }

  Future<User> getCurrentUserProfile() async {
    final access = await getAccessToken;
    if (access != null) {
      final userJson = await authService.getCurrentUserProfile(access);
      return User.fromJson(userJson);
    } else {
      // Handle the scenario where there is no valid access token
      throw Exception(
          'No valid access token. User might need to log in again.');
    }
  }

  Future<void> login(String username, String password) async {
    final json = await authService.login(username, password);
    await storeTokens(json['access'], json['refresh']);
  }

  Future<void> logout() async {
    await secureStorage.delete(key: 'access');
    await secureStorage.delete(key: 'refresh');
  }

  Future<void> signup(UserDTO user) async {
    await authService.signup(user);
  }

  Future<void> checkEmailExists(String email) async {
    await authService.checkEmailExists(email);
  }

  Future<void> resetPassword(String token, String password) async {
    await authService.resetPassword(token, password);
  }

  bool tokenHasExpired(String? token) {
    if (token == null) return true;
    return JwtDecoder.isExpired(token);
  }

  Future<void> storeTokens(String access, String refresh) async {
    await secureStorage.write(key: 'access', value: access);
    await secureStorage.write(key: 'refresh', value: refresh);
  }
}
