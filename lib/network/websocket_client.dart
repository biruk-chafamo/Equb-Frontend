import 'dart:async';

import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_event.dart';
import 'package:equb_v3_frontend/repositories/authentication_repository.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  final AuthBloc authBloc;
  final AuthRepository authRepository;

  WebSocketClient({required this.authBloc, required this.authRepository});

  Future<WebSocketChannel> connect(String wsUrl) async {
    var token = await authRepository.getAccessToken;
    if (token == null) {
      authBloc.add(AuthCheckStatus());
    }
    final channel = WebSocketChannel.connect(
      Uri.parse('$wsUrl?token=$token'),
    );
    return channel;
  }
}
