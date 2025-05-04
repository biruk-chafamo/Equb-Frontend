import 'package:equatable/equatable.dart';
import 'package:equb_v3_frontend/utils/constants.dart';

sealed class EqubsOverviewEvent extends Equatable {
  const EqubsOverviewEvent();

  @override
  List<Object> get props => [];
}

class FetchEqubs extends EqubsOverviewEvent {
  final EqubType type;

  const FetchEqubs(this.type);

  @override
  List<Object> get props => [type];
}

class FetchFocusedUserEqubs extends EqubsOverviewEvent {
  final int userId;

  const FetchFocusedUserEqubs(this.userId);

  @override
  List<Object> get props => [userId];
}
