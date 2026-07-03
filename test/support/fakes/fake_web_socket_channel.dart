import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FakeWebSocketChannel extends Fake implements WebSocketChannel {
  final _incoming = StreamController<dynamic>.broadcast();
  final FakeWebSocketSink _sink = FakeWebSocketSink();

  List<dynamic> get sent => _sink.sent;

  void emitServer(dynamic message) => _incoming.add(message);

  void emitError(Object error) => _incoming.addError(error);

  Future<void> closeServer() => _incoming.close();

  @override
  Stream<dynamic> get stream => _incoming.stream;

  @override
  WebSocketSink get sink => _sink;

  @override
  Future<void> get ready => Future.value();
}

class FakeWebSocketSink extends Fake implements WebSocketSink {
  final List<dynamic> sent = [];
  int? closeCode;
  String? closeReason;

  @override
  void add(dynamic data) => sent.add(data);

  @override
  Future<void> close([int? closeCode, String? closeReason]) async {
    this.closeCode = closeCode;
    this.closeReason = closeReason;
  }

  @override
  Future<void> get done => Future.value();
}
