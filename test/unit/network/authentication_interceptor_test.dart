import 'package:dio/dio.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_state.dart';
import 'package:equb_v3_frontend/network/interceptors/authentication_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes/fake_auth_repository.dart';

class _RecordingErrorHandler extends ErrorInterceptorHandler {
  DioException? rejected;

  @override
  void reject(DioException error) => rejected = error;
}

class _RecordingRequestHandler extends RequestInterceptorHandler {
  RequestOptions? forwarded;
  DioException? rejected;

  @override
  void next(RequestOptions options) => forwarded = options;

  @override
  void reject(DioException error, [bool callFollowingErrorInterceptor = false]) =>
      rejected = error;
}

void main() {
  late FakeAuthRepository authRepository;
  late AuthBloc authBloc;
  late AuthInterceptor interceptor;

  setUp(() {
    authRepository = FakeAuthRepository();
    authBloc = AuthBloc(authRepository: authRepository);
    interceptor = AuthInterceptor(
      authBloc: authBloc,
      authRepository: authRepository,
      baseUrl: 'https://api.equbfinance.com',
    );
  });

  tearDown(() => authBloc.close());

  group('onRequest', () {
    test('attaches the bearer token', () async {
      final handler = _RecordingRequestHandler();
      final options = RequestOptions(path: '/equbs/');

      await interceptor.onRequest(options, handler);

      expect(handler.forwarded?.headers['Authorization'],
          'Bearer access-token');
      expect(handler.rejected, isNull);
    });

    test('rejects and re-checks auth when there is no token', () async {
      authRepository.accessToken = null;
      final handler = _RecordingRequestHandler();

      await interceptor.onRequest(RequestOptions(path: '/equbs/'), handler);

      expect(handler.rejected, isNotNull);
      expect(handler.forwarded, isNull);
      await expectLater(
        authBloc.stream,
        emitsThrough(isA<AuthState>()),
      );
    });
  });

  group('onError', () {
    test('passes a response body through as the error', () {
      final options = RequestOptions(path: '/equbs/');
      final handler = _RecordingErrorHandler();

      interceptor.onError(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: options,
            statusCode: 400,
            data: {'detail': 'nope'},
          ),
        ),
        handler,
      );

      expect(handler.rejected?.error, {'detail': 'nope'});
    });

    test('survives a failure that carries no response at all', () {
      final options = RequestOptions(path: '/equbs/');
      final handler = _RecordingErrorHandler();

      interceptor.onError(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionTimeout,
        ),
        handler,
      );

      expect(handler.rejected, isNotNull);
      expect(handler.rejected?.type, DioExceptionType.connectionTimeout);
    });
  });
}
