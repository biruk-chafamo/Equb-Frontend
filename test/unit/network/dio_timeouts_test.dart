import 'package:equb_v3_frontend/network/dio_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('the shared dio client', () {
    // dio's browser adapter only completes on load, error or timeout, and it
    // never sets xhr.timeout unless these are configured. Without them an
    // aborted upload leaves the request pending and the UI spinning forever.
    test('has a send timeout so a stalled upload cannot hang', () {
      expect(DioClient.instance.options.sendTimeout, isNotNull);
      expect(DioClient.instance.options.sendTimeout, greaterThan(Duration.zero));
    });

    test('has a receive timeout so a stalled response cannot hang', () {
      expect(DioClient.instance.options.receiveTimeout, isNotNull);
      expect(
          DioClient.instance.options.receiveTimeout, greaterThan(Duration.zero));
    });

    test('has a connect timeout', () {
      expect(DioClient.instance.options.connectTimeout, isNotNull);
      expect(
          DioClient.instance.options.connectTimeout, greaterThan(Duration.zero));
    });

    test('allows uploads longer than the receive timeout', () {
      // an upload on a slow link legitimately takes longer than a response
      expect(DioClient.instance.options.sendTimeout!,
          greaterThanOrEqualTo(DioClient.instance.options.receiveTimeout!));
    });
  });
}
