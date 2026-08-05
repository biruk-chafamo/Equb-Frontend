import 'package:dio/dio.dart';
import 'package:equb_v3_frontend/network/dio_error_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin GuardedBloc<E, S> on Bloc<E, S> {
  EventHandler<T, S> guarded<T extends E>(
    Future<void> Function(T event, Emitter<S> emit) handler, {
    required S Function(String message, Object? details) onFailure,
  }) {
    return (event, emit) async {
      try {
        await handler(event, emit);
      } catch (error, stackTrace) {
        addError(error, stackTrace);
        if (emit.isDone) return;
        emit(onFailure(
          describeDioError(error),
          error is DioException ? error.response?.data : null,
        ));
      }
    };
  }
}
