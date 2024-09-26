import 'package:dio/dio.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_event.dart';
import 'package:equb_v3_frontend/repositories/authentication_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class AuthInterceptor extends Interceptor {
  final AuthBloc authBloc;
  final AuthRepository authRepository;
  final String baseUrl;
  AuthInterceptor(
      {required this.authBloc,
      required this.authRepository,
      required this.baseUrl});

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final logger = Logger();

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (!requiresValidation(options)) {
      return handler.next(options);
    }
    var token = await authRepository.getAccessToken;
    if (token == null) {
      authBloc.add(AuthCheckStatus());
      return handler.reject(
          DioException(requestOptions: options, error: 'Refresh token failed'));
    }
    options.headers.addAll({'Authorization': 'Bearer $token'});
    return handler.next(options);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  bool requiresValidation(RequestOptions options) {
    return options.path != '/api-auth/token/' &&
        options.path != '/api-auth/token/refresh/';
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e(err.response!.data);
  }
}
