import 'package:dio/dio.dart';
import 'package:equb_v3_frontend/network/dio_error_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final request = RequestOptions(path: '/equbs/');

  DioException dioError(
    DioExceptionType type, {
    int? statusCode,
    Object? data,
  }) {
    return DioException(
      requestOptions: request,
      type: type,
      response: statusCode == null
          ? null
          : Response(
              requestOptions: request, statusCode: statusCode, data: data),
    );
  }

  test('a non-Dio error falls back to the generic message', () {
    expect(describeDioError(Exception('boom')), genericErrorMessage);
    expect(describeDioError('a string'), genericErrorMessage);
  });

  group('transport failures', () {
    test('timeouts read as timeouts', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        expect(describeDioError(dioError(type)), contains('timed out'));
      }
    });

    test('a connection error mentions the connection', () {
      expect(
        describeDioError(dioError(DioExceptionType.connectionError)),
        contains('Could not reach the server'),
      );
    });

    test('a timeout with no response does not crash', () {
      final error = dioError(DioExceptionType.connectionTimeout);

      expect(error.response, isNull);
      expect(describeDioError(error), isNotEmpty);
    });
  });

  group('response failures', () {
    test('401 and 403 read as a permission problem', () {
      for (final status in [401, 403]) {
        expect(
          describeDioError(
              dioError(DioExceptionType.badResponse, statusCode: status)),
          contains('not allowed'),
        );
      }
    });

    test('404 reads as not found', () {
      expect(
        describeDioError(
            dioError(DioExceptionType.badResponse, statusCode: 404)),
        contains('could not be found'),
      );
    });

    test('5xx reads as a server problem', () {
      expect(
        describeDioError(
            dioError(DioExceptionType.badResponse, statusCode: 503)),
        contains('server had a problem'),
      );
    });

    test('a detail key is surfaced verbatim', () {
      expect(
        describeDioError(dioError(
          DioExceptionType.badResponse,
          statusCode: 400,
          data: {'detail': 'Bid must exceed the current highest.'},
        )),
        'Bid must exceed the current highest.',
      );
    });

    test('a field error list surfaces its first message', () {
      expect(
        describeDioError(dioError(
          DioExceptionType.badResponse,
          statusCode: 400,
          data: {
            'amount': ['Must be at least 1.00', 'and a number']
          },
        )),
        'Must be at least 1.00',
      );
    });

    test('a plain string body is surfaced', () {
      expect(
        describeDioError(dioError(
          DioExceptionType.badResponse,
          statusCode: 400,
          data: 'Bad request',
        )),
        'Bad request',
      );
    });

    test('an unreadable body falls back to the generic message', () {
      expect(
        describeDioError(dioError(
          DioExceptionType.badResponse,
          statusCode: 400,
          data: {'amount': <String>[]},
        )),
        genericErrorMessage,
      );
    });
  });
}
