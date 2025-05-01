part of 'user_bloc.dart';

enum UserStatus { initial, loading, success, failure }

class UserState extends Equatable {
  const UserState({
    required this.users,
    this.currentUser,
    this.error,
    this.status = UserStatus.initial,
    this.focusedUser,
    this.profilePictures = const {},
  });

  final List<User> users;
  final User? currentUser;
  final String? error;
  final UserStatus status;
  final User? focusedUser;
  final Map<int, ImageProvider?> profilePictures;

  @override
  List<Object?> get props =>
      [status, users, error, currentUser, focusedUser, profilePictures];

  UserState copyWith(
      {UserStatus? status,
      List<User>? users,
      String? error,
      User? currentUser,
      User? focusedUser,
      Map<int, ImageProvider?>? profilePictures}) {
    return UserState(
      status: status ?? this.status,
      users: users ?? this.users,
      error: error ?? this.error,
      currentUser: currentUser ?? this.currentUser,
      focusedUser: focusedUser ?? this.focusedUser,
      profilePictures: profilePictures ?? this.profilePictures,
    );
  }
}
