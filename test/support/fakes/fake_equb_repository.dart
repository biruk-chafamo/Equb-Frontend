import 'package:equb_v3_frontend/models/equb/equb.dart';
import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/repositories/equb_repository.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../builders/equb_builder.dart';
import 'fake_web_socket_channel.dart';

class FakeEqubRepository extends Fake implements EqubRepository {
  final List<String> calls = [];

  List<EqubDetail> equbsResult = const [];
  List<EqubDetail> focusedUserEqubsResult = const [];
  EqubDetail Function(int id) equbDetailResult = (id) => buildEqubDetail(id: id);
  EqubDetail? createEqubResult;
  EqubDetail? placeBidResult;
  FakeWebSocketChannel wsChannel = FakeWebSocketChannel();

  Object? nextError;

  void _maybeThrow() {
    final error = nextError;
    if (error != null) {
      nextError = null;
      throw error;
    }
  }

  @override
  Future<WebSocketChannel> startEqubWsChannel() async {
    calls.add('startEqubWsChannel()');
    _maybeThrow();
    return wsChannel;
  }

  @override
  Future<EqubDetail> getEqubDetail(int id) async {
    calls.add('getEqubDetail($id)');
    _maybeThrow();
    return equbDetailResult(id);
  }

  @override
  Future<List<EqubDetail>> getEqubs(EqubType type) async {
    calls.add('getEqubs($type)');
    _maybeThrow();
    return equbsResult;
  }

  @override
  Future<List<EqubDetail>> getFocusedUserEqubs(int userId) async {
    calls.add('getFocusedUserEqubs($userId)');
    _maybeThrow();
    return focusedUserEqubsResult;
  }

  @override
  Future<EqubDetail> createEqub(EqubCreationDTO equb) async {
    calls.add('createEqub(${equb.name})');
    _maybeThrow();
    return createEqubResult ?? buildEqubDetail(name: equb.name);
  }

  @override
  Future<EqubDetail> palceBid(int id, double bidAmount) async {
    calls.add('placeBid($id, $bidAmount)');
    _maybeThrow();
    return placeBidResult ?? equbDetailResult(id);
  }
}
