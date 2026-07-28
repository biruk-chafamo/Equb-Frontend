import 'package:dio/dio.dart';
import 'package:equb_v3_frontend/network/dio_error_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin GuardedBloc<E, S> on Bloc<E, S> {
  Future<void> guard(
    Emitter<S> emit,
    Future<void> Function() body, {
    required S Function(String message, Object? details) onFailure,
  }) async {
    try {
      await body();
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      if (emit.isDone) return;
      emit(onFailure(
        describeDioError(error),
        error is DioException ? error.response?.data : null,
      ));
    }
  }
}
