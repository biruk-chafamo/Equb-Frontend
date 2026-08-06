import 'dart:convert';
import 'dart:io';

import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

// Platform enum for authentication
enum AuthPlatform {
  web('web'),
  ios('ios'),
  android('android');

  const AuthPlatform(this.value);
  final String value;

  static AuthPlatform get current {
    if (kIsWeb) {
      return AuthPlatform.web;
    } else if (Platform.isIOS) {
      return AuthPlatform.ios;
    } else if (Platform.isAndroid) {
      return AuthPlatform.android;
    } else {
      return AuthPlatform.web; // fallback
    }
  }
}

// Custom exception for Google-only accounts
class GoogleOnlyAccountException implements Exception {
  final String message;
  GoogleOnlyAccountException(this.message);
}

// Custom exception for Google sign-in errors, carries the backend's
// specific message (e.g. "account already exists, use your password").
class GoogleAuthException implements Exception {
  final String message;
  GoogleAuthException(this.message);
}

class AuthService {
  final String baseUrl;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // Let iOS use the client ID from GoogleService-Info.plist
    // Web will use the meta tag in index.html
  );

  AuthService({required this.baseUrl});

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api-auth/token/'),
      body: jsonEncode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      // Store that this user uses password authentication
      await _storeAuthMethod(username, 'password');
      return result;
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

  // Store authentication method for user experience
  Future<void> _storeAuthMethod(String email, String method) async {
    await secureStorage.write(key: 'auth_method_$email', value: method);
  }

  Future<String?> getAuthMethod(String email) async {
    return await secureStorage.read(key: 'auth_method_$email');
  }

  // Smart password reset that handles Google users
  Future<void> checkEmailExists(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api-auth/smart-password-reset/'),
      body: jsonEncode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 400) {
      final errorData = json.decode(response.body);
      if (errorData['error'] == 'google_only_account') {
        // Store that this email uses Google authentication
        await _storeAuthMethod(email, 'google');
        throw GoogleOnlyAccountException(errorData['message']);
      }
      throw Exception(errorData['message'] ?? 'Failed to reset password');
    } else if (response.statusCode != 200) {
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

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        throw Exception('Google sign-in was cancelled');
      }
      return await completeGoogleSignIn(account);
    } catch (e) {
      await _googleSignIn.signOut(); // Clean up on error
      rethrow;
    }
  }

  /// Web: `.signIn()` can't reliably provide an idToken, so the login screen
  /// uses this plus the rendered Sign-In button instead.
  Future<GoogleSignInAccount?> trySilentGoogleSignIn() {
    return _googleSignIn.signInSilently();
  }

  Stream<GoogleSignInAccount?> get onGoogleUserChanged =>
      _googleSignIn.onCurrentUserChanged;

  Future<Map<String, dynamic>> completeGoogleSignIn(
      GoogleSignInAccount account) async {
    final GoogleSignInAuthentication auth = await account.authentication;
    final String? token = auth.idToken;

    if (token == null) {
      throw Exception('Failed to get Google ID token');
    }

    final currentPlatform = AuthPlatform.current;
    final requestBody = {
      'id_token': token,
      'platform': currentPlatform.value,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api-auth/google/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      // Store that this email uses Google authentication
      if (result['user'] != null && result['user']['email'] != null) {
        await _storeAuthMethod(result['user']['email'], 'google');
      }
      return result;
    } else if (response.statusCode == 400) {
      final errorData = json.decode(response.body);
      throw GoogleAuthException(
          errorData['message'] ?? 'Google authentication failed');
    } else {
      throw GoogleAuthException('Google authentication failed');
    }
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }
}
