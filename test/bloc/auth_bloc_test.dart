import 'package:bloc_test/bloc_test.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_event.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_state.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/services/authentication_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/builders/user_builder.dart';
import '../support/fakes/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository authRepository;
  final alice = buildUser(id: 1, firstName: 'Alice');

  setUp(() {
    authRepository = FakeAuthRepository()..currentUserProfile = alice;
  });

  AuthBloc build() => AuthBloc(authRepository: authRepository);

  final signupDto = UserDTO(
    username: 'alice',
    password: 'pw',
    password2: 'pw',
    firstName: 'Alice',
    lastName: 'Bekele',
    email: 'alice@example.com',
  );

  group('login', () {
    blocTest<AuthBloc, AuthState>(
      'authenticates with the fetched profile',
      build: build,
      act: (bloc) =>
          bloc.add(const AuthLoginRequested(username: 'alice', password: 'pw')),
      expect: () => [AuthLoading(), AuthAuthenticated(alice)],
      verify: (_) {
        expect(authRepository.calls,
            containsAllInOrder(['login(alice)', 'getCurrentUserProfile()']));
      },
    );

    blocTest<AuthBloc, AuthState>(
      'reports a failure rather than hanging when the request fails',
      build: build,
      seed: () => AuthInitial(),
      act: (bloc) {
        authRepository.nextError = Exception('boom');
        bloc.add(const AuthLoginRequested(username: 'alice', password: 'wrong'));
      },
      expect: () => [
        AuthLoading(),
        isA<AuthError>()
            .having((e) => e.message, 'message', 'Failed to log in.')
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'does not authenticate when the profile fetch fails after login',
      build: build,
      act: (bloc) {
        authRepository.profileError = Exception('500');
        bloc.add(const AuthLoginRequested(username: 'alice', password: 'pw'));
      },
      expect: () => [AuthLoading(), isA<AuthError>()],
      verify: (_) {
        expect(authRepository.calls, contains('login(alice)'));
      },
    );
  });

  group('logout', () {
    blocTest<AuthBloc, AuthState>(
      'ends in an unauthenticated state',
      build: build,
      act: (bloc) => bloc.add(const AuthLogoutRequested()),
      expect: () => [AuthLoading(), AuthUnauthenticated()],
      verify: (_) => expect(authRepository.calls, contains('logout()')),
    );

    blocTest<AuthBloc, AuthState>(
      'surfaces a failure instead of silently staying logged in',
      build: build,
      act: (bloc) {
        authRepository.nextError = Exception('network down');
        bloc.add(const AuthLogoutRequested());
      },
      expect: () => [AuthLoading(), isA<AuthError>()],
    );
  });

  group('check status', () {
    blocTest<AuthBloc, AuthState>(
      'authenticates when a profile is reachable',
      build: build,
      act: (bloc) => bloc.add(AuthCheckStatus()),
      expect: () => [AuthAuthenticated(alice)],
    );

    blocTest<AuthBloc, AuthState>(
      'falls back to unauthenticated rather than erroring',
      build: build,
      act: (bloc) {
        authRepository.nextError = Exception('401');
        bloc.add(AuthCheckStatus());
      },
      expect: () => [AuthUnauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits no loading state, so a refresh cannot flash the login screen',
      build: build,
      act: (bloc) => bloc.add(AuthCheckStatus()),
      expect: () => [isA<AuthAuthenticated>()],
    );
  });

  group('signup', () {
    blocTest<AuthBloc, AuthState>(
      'signs up, logs in, then authenticates',
      build: build,
      act: (bloc) => bloc.add(AuthSignUpRequested(user: signupDto)),
      expect: () => [AuthLoading(), AuthAuthenticated(alice)],
      verify: (_) {
        expect(
          authRepository.calls,
          containsAllInOrder(
              ['signup(alice)', 'login(alice)', 'getCurrentUserProfile()']),
        );
      },
    );

    blocTest<AuthBloc, AuthState>(
      'carries the backend field errors through for the form to render',
      build: build,
      act: (bloc) {
        authRepository.nextError = {
          'email': ['already in use']
        };
        bloc.add(AuthSignUpRequested(user: signupDto));
      },
      expect: () => [
        AuthLoading(),
        isA<AuthError>()
            .having((e) => e.message, 'message', 'Failed to sign up.')
            .having((e) => e.parameterErrorJSON, 'parameterErrorJSON',
                containsPair('email', ['already in use'])),
      ],
    );
  });

  group('password reset', () {
    blocTest<AuthBloc, AuthState>(
      'moves to the reset step once the email is known',
      build: build,
      act: (bloc) =>
          bloc.add(const CheckEmailExistsRequested(email: 'alice@example.com')),
      expect: () => [
        AuthLoading(),
        const AuthPasswordResetRequested(email: 'alice@example.com'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'reports the google-only message verbatim',
      build: build,
      act: (bloc) {
        authRepository.nextError =
            GoogleOnlyAccountException('Use Google to sign in');
        bloc.add(const CheckEmailExistsRequested(email: 'alice@example.com'));
      },
      expect: () => [
        AuthLoading(),
        isA<AuthError>()
            .having((e) => e.message, 'message', 'Use Google to sign in'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'returns to unauthenticated so the user logs in with the new password',
      build: build,
      act: (bloc) => bloc.add(const AuthPasswordResetRequestedEvent(
          token: 'tok', password: 'newpw')),
      expect: () => [AuthLoading(), AuthUnauthenticated()],
    );
  });

  group('google sign in', () {
    blocTest<AuthBloc, AuthState>(
      'authenticates through the repository seam',
      build: build,
      act: (bloc) => bloc.add(const AuthGoogleSignInRequested()),
      expect: () => [AuthLoading(), AuthAuthenticated(alice)],
      verify: (_) =>
          expect(authRepository.calls, contains('signInWithGoogle()')),
    );

    blocTest<AuthBloc, AuthState>(
      'reports the google message verbatim',
      build: build,
      act: (bloc) {
        authRepository.nextError = GoogleAuthException('popup closed');
        bloc.add(const AuthGoogleSignInRequested());
      },
      expect: () => [
        AuthLoading(),
        isA<AuthError>().having((e) => e.message, 'message', 'popup closed'),
      ],
    );
  });
}
