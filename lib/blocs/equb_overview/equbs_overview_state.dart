import 'package:equatable/equatable.dart';
import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/utils/constants.dart';

enum EqubsOverviewStatus { initial, loading, success, failure }

final class EqubsOverviewState extends Equatable {
  const EqubsOverviewState({
    this.equbsOverview = const [],
    this.status = EqubsOverviewStatus.initial,
    this.type = EqubType.pending,
    this.focusedUserEqubsOverview = const [],
    this.error,
  });

  final EqubsOverviewStatus status;
  final List<EqubDetail> equbsOverview;
  final List<EqubDetail> focusedUserEqubsOverview;
  final String? error;
  final EqubType type;

  EqubsOverviewState copyWith({
    EqubsOverviewStatus? status,
    List<EqubDetail>? equbsOverview,
    List<EqubDetail>? focusedUserEqubsOverview,
    String? error,
    EqubType? type,
  }) {
    return EqubsOverviewState(
      status: status ?? this.status,
      equbsOverview:
          equbsOverview ?? this.equbsOverview,
      focusedUserEqubsOverview: focusedUserEqubsOverview ?? this.focusedUserEqubsOverview,
      error: error ?? this.error,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [status, equbsOverview, error, type, focusedUserEqubsOverview];
}
