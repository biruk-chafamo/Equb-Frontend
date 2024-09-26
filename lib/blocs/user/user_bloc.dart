import 'package:equatable/equatable.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(const UserState(users: [])) {
    on<FetchUsersByName>(_onFetchUsersByName);
    on<FetchUserById>(_onFetchUserById);
    on<FetchCurrentUser>(_onFetchCurrentUser);
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
}
