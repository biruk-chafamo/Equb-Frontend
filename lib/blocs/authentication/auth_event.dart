import 'package:equatable/equatable.dart';
import 'package:equb_v3_frontend/models/user/user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String username;
  final String password;

  const AuthLoginRequested({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();

  @override
  List<Object> get props => [];
}

class AuthCheckStatus extends AuthEvent {}

class AuthSignUpRequested extends AuthEvent {
  final UserDTO user;

  const AuthSignUpRequested({required this.user});

  @override
  List<Object> get props => [user];
}

class CheckEmailExistsRequested extends AuthEvent {
  final String email;

  const CheckEmailExistsRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthPasswordResetRequestedEvent extends AuthEvent {
  final String token;
  final String password;

  const AuthPasswordResetRequestedEvent({required this.token, required this.password});

  @override
  List<Object> get props => [token, password];
}