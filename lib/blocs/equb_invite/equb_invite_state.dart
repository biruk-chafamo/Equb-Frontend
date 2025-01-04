part of 'equb_invite_bloc.dart';

enum EqubInviteStatus { initial, loading, success, failure }

class EqubInviteState extends Equatable {
  const EqubInviteState({
    this.equbInvites = const [],
    this.selectedEqubInvite,
    this.status = EqubInviteStatus.initial,
    this.searchedUsers = const [],
    this.recommendedUsers = const [],
    this.equb,
    this.error,
  });

  final EqubInviteStatus status;
  final List<EqubInvite> equbInvites;
  final EqubInvite? selectedEqubInvite;
  final List<UserWithInviteStatus> searchedUsers;
  final List<UserWithInviteStatus> recommendedUsers;
  final EqubDetail? equb;
  final String? error;

  @override
  List<Object?> get props =>
      [status, equbInvites, selectedEqubInvite, equb, error];

  EqubInviteState copyWith({
    EqubInviteStatus? status,
    List<EqubInvite>? equbInvites,
    EqubInvite? selectedEqubInvite,
    List<UserWithInviteStatus>? searchedUsers,
    List<UserWithInviteStatus>? recommendedUsers,
    EqubDetail? equb,
    String? error,
  }) {
    return EqubInviteState(
      status: status ?? this.status,
      equbInvites: equbInvites ?? this.equbInvites,
      selectedEqubInvite: selectedEqubInvite ?? this.selectedEqubInvite,
      equb: equb ?? this.equb,
      error: error ?? this.error,
      searchedUsers: searchedUsers ?? this.searchedUsers,
      recommendedUsers: recommendedUsers ?? this.recommendedUsers,
    );
  }
}
