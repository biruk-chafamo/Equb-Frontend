import 'package:equatable/equatable.dart';
import 'package:equb_v3_frontend/models/equb/equb_detail.dart';

enum EqubDetailStatus { initial, loading, success, failure, equbCreated }

final class EqubDetailState extends Equatable {
  const EqubDetailState({
    this.equbDetail,
    this.status = EqubDetailStatus.initial,
    this.equbWsChannelStarted = false,
    this.error,
    this.parameterErrorJSON,
  });

  final EqubDetailStatus status;
  final EqubDetail? equbDetail;
  final bool equbWsChannelStarted;
  final String? error;
  final dynamic parameterErrorJSON;

  EqubDetailState copyWith({
    EqubDetailStatus? status,
    EqubDetail? equbDetail,
    bool? equbWsChannelStarted,
    dynamic parameterErrorJSON,
  }) {
    return EqubDetailState(
      equbDetail: equbDetail ?? this.equbDetail,
      status: status ?? this.status,
      equbWsChannelStarted: equbWsChannelStarted ?? this.equbWsChannelStarted,
      parameterErrorJSON: parameterErrorJSON ?? this.parameterErrorJSON,
    );
  }

  @override
  List<Object?> get props => [
        status,
        equbDetail,
      ];
}
