import 'package:equatable/equatable.dart';
import 'package:equb_v3_frontend/models/equb/equb_detail.dart';

enum EqubDetailStatus { initial, loading, success, failure, equbCreated}

final class EqubDetailState extends Equatable {
  const EqubDetailState({
    this.equbDetail,
    this.status = EqubDetailStatus.initial,
    this.error,
    this.parameterErrorJSON,
  });

  final EqubDetailStatus status;
  final EqubDetail? equbDetail;
  final String? error;
  final dynamic parameterErrorJSON;

  EqubDetailState copyWith({
    EqubDetailStatus Function()? status,
    EqubDetail Function()? equbDetail,
  }) {
    return EqubDetailState(
      equbDetail: equbDetail != null ? equbDetail() : this.equbDetail,
      status: status != null ? status() : this.status,
    );
  }

  @override
  List<Object?> get props => [
        status,
        equbDetail,
      ];
}
