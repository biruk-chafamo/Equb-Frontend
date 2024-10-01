import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc()
      : super(const NavigationState(0, status: NavigationStatus.initial)) {
    on<updateIndexRequested>(_onUpdateStateRequested);
  }

  void _onUpdateStateRequested(
      updateIndexRequested event, Emitter<NavigationState> emit) async {
    emit(state.copyWith(
      status: NavigationStatus.loading,
    ));
    emit(state.copyWith(
      status: NavigationStatus.success,
      index: event.index,
    ));
  }
}
