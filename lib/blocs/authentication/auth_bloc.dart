
import 'package:equb_v3_frontend/repositories/authentication_repository.dart';
import 'package:equb_v3_frontend/services/authentication_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckStatus>(_onCheckStatus);
    on<AuthSignUpRequested>(_onSignupRequested);
    on<CheckEmailExistsRequested>(_onCheckEmailExistsRequested);
    on<AuthPasswordResetRequestedEvent>(_onPasswordResetRequested);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthGoogleAccountReceived>(_onGoogleAccountReceived);
  }

  void _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.login(event.username, event.password);
      final user = await authRepository.getCurrentUserProfile();
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError("Failed to log in.", parameterErrorJSON: e));
    }
  }

  void _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onCheckStatus(AuthCheckStatus event, Emitter<AuthState> emit) async {
    try {
      final user = await authRepository.getCurrentUserProfile();
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  void _onSignupRequested(
      AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signup(event.user);
      await authRepository.login(event.user.username, event.user.password);
      final user = await authRepository.getCurrentUserProfile();
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError("Failed to sign up.", parameterErrorJSON: e));
    }
  }

  void _onCheckEmailExistsRequested(
      CheckEmailExistsRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.checkEmailExists(event.email);
      emit(AuthPasswordResetRequested(email: event.email));
    } on GoogleOnlyAccountException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onPasswordResetRequested(
      AuthPasswordResetRequestedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.resetPassword(event.token, event.password);
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError("Failed to reset password.", parameterErrorJSON: e));
    }
  }

  void _onGoogleSignInRequested(
      AuthGoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signInWithGoogle();
      final user = await authRepository.getCurrentUserProfile();
      emit(AuthAuthenticated(user));
    } on GoogleAuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onGoogleAccountReceived(
      AuthGoogleAccountReceived event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.completeGoogleSignIn(event.account);
      final user = await authRepository.getCurrentUserProfile();
      emit(AuthAuthenticated(user));
    } on GoogleAuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
