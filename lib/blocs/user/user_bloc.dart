import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:equb_v3_frontend/blocs/payment_method/payment_method_bloc.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final PaymentMethodBloc paymentMethodBloc;
  late StreamSubscription paymentMethodBlocSubscription;

  UserBloc({required this.userRepository, required this.paymentMethodBloc})
      : super(const UserState(users: [])) {
    on<FetchUsersByName>(_onFetchUsersByName);
    on<FetchUserById>(_onFetchUserById);
    on<FetchCurrentUser>(_onFetchCurrentUser);
    on<UpdateProfilePicture>(_onUpdateProfilePicture);
    on<FetchProfilePicture>(_onFetchProfilePicture);

    paymentMethodBlocSubscription =
        paymentMethodBloc.stream.listen((paymentState) {
      if (paymentState.status == PaymentMethodStatus.newMethodCreated) {
        add(const FetchCurrentUser());
      }
    });
  }

  @override
  Future<void> close() {
    paymentMethodBlocSubscription.cancel();
    return super.close();
  }

  void _onFetchUsersByName(
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

  void _onFetchUserById(FetchUserById event, Emitter<UserState> emit) async {
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

  void _onFetchCurrentUser(
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

  void _onUpdateProfilePicture(
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

  void _onFetchProfilePicture(
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
