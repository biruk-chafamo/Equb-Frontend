import 'package:dio/dio.dart';

const String genericErrorMessage = 'Something went wrong. Please try again.';

String describeDioError(Object error) {
  if (error is! DioException) return genericErrorMessage;

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'The connection timed out. Please try again.';
    case DioExceptionType.connectionError:
      return 'Could not reach the server. Check your connection.';
    case DioExceptionType.cancel:
      return 'The request was cancelled.';
    case DioExceptionType.badCertificate:
      return 'The server certificate could not be verified.';
    case DioExceptionType.badResponse:
    case DioExceptionType.unknown:
      return _describeResponse(error);
  }
}

String _describeResponse(DioException error) {
  final status = error.response?.statusCode;
  if (status == null) return genericErrorMessage;
  if (status == 401 || status == 403) {
    return 'You are not allowed to do that.';
  }
  if (status == 404) return 'That could not be found.';
  if (status >= 500) return 'The server had a problem. Please try again.';

  final detail = _detailFrom(error.response?.data);
  return detail ?? genericErrorMessage;
}

String? _detailFrom(Object? data) {
  if (data is String && data.trim().isNotEmpty) return data;
  if (data is! Map) return null;

  final detail = data['detail'] ?? data['error'] ?? data['message'];
  if (detail is String && detail.trim().isNotEmpty) return detail;

  for (final value in data.values) {
    if (value is List && value.isNotEmpty && value.first is String) {
      return value.first as String;
    }
    if (value is String && value.trim().isNotEmpty) return value;
  }
  return null;
}
