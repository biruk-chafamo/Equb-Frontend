import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/repositories/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../builders/user_builder.dart';

class FakeAuthRepository extends Fake implements AuthRepository {
  final List<String> calls = [];

  String? accessToken = 'access-token';
  User? currentUserProfile;

  Object? nextError;

  void _maybeThrow() {
    final error = nextError;
    if (error != null) {
      nextError = null;
      throw error;
    }
  }

  @override
  Future<String?> get getAccessToken async {
    calls.add('getAccessToken');
    return accessToken;
  }

  @override
  Future<User> getCurrentUserProfile() async {
    calls.add('getCurrentUserProfile()');
    _maybeThrow();
    return currentUserProfile ?? buildUser();
  }

  @override
  Future<void> login(String username, String password) async {
    calls.add('login($username)');
    _maybeThrow();
    accessToken = 'access-token';
  }

  @override
  Future<void> logout() async {
    calls.add('logout()');
    _maybeThrow();
    accessToken = null;
  }

  @override
  Future<void> signup(UserDTO user) async {
    calls.add('signup(${user.username})');
    _maybeThrow();
  }

  @override
  Future<void> checkEmailExists(String email) async {
    calls.add('checkEmailExists($email)');
    _maybeThrow();
  }

  @override
  Future<void> resetPassword(String token, String password) async {
    calls.add('resetPassword($token)');
    _maybeThrow();
  }

  @override
  Future<void> storeTokens(String access, String refresh) async {
    calls.add('storeTokens()');
    accessToken = access;
  }

  @override
  Future<void> signInWithGoogle() async {
    calls.add('signInWithGoogle()');
    _maybeThrow();
  }

  @override
  Future<void> completeGoogleSignIn(GoogleSignInAccount account) async {
    calls.add('completeGoogleSignIn(${account.email})');
    _maybeThrow();
  }
}
