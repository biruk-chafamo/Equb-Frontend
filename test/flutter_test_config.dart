import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  _mockChannel('plugins.it_nomads.com/flutter_secure_storage', (call) async {
    switch (call.method) {
      case 'readAll':
        return <String, String>{};
      case 'containsKey':
        return false;
      default:
        return null;
    }
  });

  _mockChannel('plugins.flutter.io/path_provider', (call) async => '.');
  _mockChannel('plugins.flutter.io/image_picker', (call) async => null);

  await testMain();
}

void _mockChannel(String name, Future<Object?>? Function(MethodCall) handler) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(MethodChannel(name), handler);
}
