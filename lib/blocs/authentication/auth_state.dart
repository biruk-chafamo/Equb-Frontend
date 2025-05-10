import 'package:equatable/equatable.dart';
import 'package:equb_v3_frontend/models/user/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  final bool isProfileFetched;

  const AuthAuthenticated(this.user, {this.isProfileFetched = false});

  AuthAuthenticated copyWith({User? user, bool? isProfileFetched}) {
    return AuthAuthenticated(
      user ?? this.user,
      isProfileFetched: isProfileFetched ?? this.isProfileFetched,
    );
  }

  @override
  List<Object> get props => [user, isProfileFetched];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  final dynamic parameterErrorJSON;

  const AuthError(this.message, {this.parameterErrorJSON = const {}});

  @override
  List<Object> get props => [message, parameterErrorJSON];
}

class AuthPasswordResetRequested extends AuthState {
  final String email;

  const AuthPasswordResetRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthPasswordReset extends AuthState {
  final String password;

  const AuthPasswordReset({required this.password});

  @override
  List<Object> get props => [password];
}