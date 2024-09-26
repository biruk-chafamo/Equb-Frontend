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
