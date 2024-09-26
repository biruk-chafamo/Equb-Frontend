part of 'user_bloc.dart';

enum UserStatus { initial, loading, success, failure }

class UserState extends Equatable {
  const UserState({
    required this.users,
    this.currentUser,
    this.error,
    this.status = UserStatus.initial,
    this.focusedUser,
  });

  final List<User> users;
  final User? currentUser;
  final String? error;
  final UserStatus status;
  final User? focusedUser;

  @override
  List<Object?> get props => [status, users, error, currentUser, focusedUser];

  UserState copyWith({
    UserStatus? status,
    List<User>? users,
    String? error,
    User? currentUser,
    User? focusedUser,
  }) {
    return UserState(
      status: status ?? this.status,
      users: users ?? this.users,
      error: error ?? this.error,
      currentUser: currentUser ?? this.currentUser,
      focusedUser: focusedUser ?? this.focusedUser,
    );
  }
}
