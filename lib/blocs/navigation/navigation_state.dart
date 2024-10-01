part of 'navigation_bloc.dart';

enum NavigationStatus { initial, loading, success, failure }

class NavigationState extends Equatable {
  const NavigationState(this.index, {required this.status, this.error = ''});

  final int index;
  final NavigationStatus status;
  final String error;

  @override
  List<Object?> get props => [index, status, error];

  NavigationState copyWith({
    int? index,
    NavigationStatus? status,
    String? error,
  }) {
    return NavigationState(
      index ?? this.index,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
