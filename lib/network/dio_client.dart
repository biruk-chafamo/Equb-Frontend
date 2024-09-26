import 'package:dio/dio.dart';
import 'interceptors/authentication_interceptor.dart';

class DioClient {
  static final Dio _dio = Dio();

  static Dio get instance => _dio;

  static void setupInterceptors(AuthInterceptor authInterceptor) {
    // Check if an interceptor of the same type is already added
    if (!_dio.interceptors.any((element) => element.runtimeType == authInterceptor.runtimeType)) {
      _dio.interceptors.add(authInterceptor);
    }
  }
}
