import 'package:dio/dio.dart';
import 'interceptors/authentication_interceptor.dart';

class DioClient {
  // Without these the browser adapter leaves xhr.timeout at 0 and only
  // completes on load or error - an aborted request hangs forever.
  static final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 30),
  ));

  static Dio get instance => _dio;

  static void setupInterceptors(AuthInterceptor authInterceptor) {
    // Check if an interceptor of the same type is already added
    if (!_dio.interceptors.any((element) => element.runtimeType == authInterceptor.runtimeType)) {
      _dio.interceptors.add(authInterceptor);
    }
  }
}
