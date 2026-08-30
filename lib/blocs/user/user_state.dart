part of 'user_bloc.dart';

enum UserStatus { initial, loading, success, failure }

class UserState extends Equatable {
  const UserState({
    required this.users,
    this.currentUser,
    this.error,
    this.status = UserStatus.initial,
    this.focusedUser,
    this.isUploadingPicture = false,
    this.pictureUploadError,
  });

  final List<User> users;
  final User? currentUser;
  final String? error;
  final UserStatus status;
  final User? focusedUser;
  final bool isUploadingPicture;
  final String? pictureUploadError;

  @override
  List<Object?> get props =>
      [status, users, error, currentUser, focusedUser, isUploadingPicture, pictureUploadError];

  UserState copyWith(
      {UserStatus? status,
      List<User>? users,
      String? error,
      User? currentUser,
      User? focusedUser,
      bool? isUploadingPicture,
      String? pictureUploadError,
      bool clearError = false,
      bool clearPictureUploadError = false}) {
    return UserState(
      status: status ?? this.status,
      users: users ?? this.users,
      error: clearError ? null : (error ?? this.error),
      currentUser: currentUser ?? this.currentUser,
      focusedUser: focusedUser ?? this.focusedUser,
      isUploadingPicture: isUploadingPicture ?? this.isUploadingPicture,
      pictureUploadError: clearPictureUploadError
          ? null
          : (pictureUploadError ?? this.pictureUploadError),
    );
  }
}
