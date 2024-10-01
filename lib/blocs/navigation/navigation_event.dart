part of 'navigation_bloc.dart';

sealed class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class updateIndexRequested extends NavigationEvent {
  final int index;

  const updateIndexRequested(this.index);

  @override
  List<Object> get props => [index];
}
