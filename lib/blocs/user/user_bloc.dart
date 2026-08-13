import 'package:equatable/equatable.dart';
import 'package:equb_v3_frontend/blocs/common/guarded_bloc.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState>
    with GuardedBloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository})
      : super(const UserState(users: [])) {
    on<FetchUsersByName>(guarded(_onFetchUsersByName, onFailure: _failure));
    on<FetchUserById>(guarded(_onFetchUserById, onFailure: _failure));
    on<FetchCurrentUser>(guarded(_onFetchCurrentUser, onFailure: _failure));
    on<UpdateProfilePicture>(
        guarded(_onUpdateProfilePicture, onFailure: _failure));
    on<FetchProfilePicture>(
        guarded(_onFetchProfilePicture, onFailure: _failure));
  }

  UserState _failure(String message, Object? _) =>
      state.copyWith(status: UserStatus.failure, error: message);

  Future<void> _onFetchUsersByName(
      FetchUsersByName event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: UserStatus.loading));
    final users = await userRepository.getUsersByName(
      event.name,
    );
    emit(
      state.copyWith(
        status: UserStatus.success,
        users: users,
      ),
    );
  }

  Future<void> _onFetchUserById(
      FetchUserById event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: UserStatus.loading));
    final user = await userRepository.getUser(
      event.id,
    );
    emit(
      state.copyWith(
        status: UserStatus.success,
        focusedUser: user,
      ),
    );
  }

  Future<void> _onFetchCurrentUser(
      FetchCurrentUser event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: UserStatus.loading));
    final user = await userRepository.getCurrentUser();
    emit(
      state.copyWith(
        status: UserStatus.success,
        currentUser: user,
      ),
    );
  }

  Future<void> _onUpdateProfilePicture(
      UpdateProfilePicture event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: UserStatus.loading));
    final updatedUser = await userRepository.updateProfilePicture(
        state.currentUser!.id, event.profilePicture);
    emit(
      state.copyWith(
        status: UserStatus.success,
        currentUser: updatedUser,
      ),
    );
  }

  Future<void> _onFetchProfilePicture(
      FetchProfilePicture event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      final profilePictureUrl =
          await userRepository.getProfilePicture(event.url, event.userId);
      emit(state.copyWith(status: UserStatus.success, profilePictures: {
        ...state.profilePictures,
        event.userId: profilePictureUrl
      }));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.failure));
    }
  }
}
