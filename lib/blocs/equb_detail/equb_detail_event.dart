import 'package:equatable/equatable.dart';
import 'package:equb_v3_frontend/models/equb/equb.dart';

sealed class EqubDetailEvent extends Equatable {
  const EqubDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchEqubDetail extends EqubDetailEvent {
  final int equbId;

  const FetchEqubDetail(this.equbId);

  @override
  List<Object> get props => [equbId];
}

class PlaceBid extends EqubDetailEvent {
  final int equbId;
  final double bidAmount;

  const PlaceBid(this.equbId, this.bidAmount);

  @override
  List<Object> get props => [equbId, bidAmount];
}

class CreateEqub extends EqubDetailEvent {
  final EqubCreationDTO equb;

  const CreateEqub(this.equb);

  @override
  List<Object> get props => [equb];
}
