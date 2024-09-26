import 'package:equatable/equatable.dart';
import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/utils/constants.dart';

enum EqubsOverviewStatus { initial, loading, success, failure }

final class EqubsOverviewState extends Equatable {
  const EqubsOverviewState({
    this.equbsOverview = const [],
    this.status = EqubsOverviewStatus.initial,
    this.type = EqubType.pending,
    this.error,
  });

  final EqubsOverviewStatus status;
  final List<EqubDetail> equbsOverview;
  final String? error;
  final EqubType type;

  EqubsOverviewState copyWith({
    EqubsOverviewStatus Function()? status,
    List<EqubDetail> Function()? equbsOverview,
  }) {
    return EqubsOverviewState(
      type: type,
      equbsOverview:
          equbsOverview != null ? equbsOverview() : this.equbsOverview,
      status: status != null ? status() : this.status,
    );
  }

  @override
  List<Object?> get props => [status, equbsOverview, error, type];
}
