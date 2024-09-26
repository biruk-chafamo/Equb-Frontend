part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class FetchUsersByName extends UserEvent {
  final String name;

  const FetchUsersByName(this.name);

  @override
  List<Object> get props => [name];
}

class FetchUserById extends UserEvent {
  final int id;

  const FetchUserById(this.id);

  @override
  List<Object> get props => [id];
}

class FetchCurrentUser extends UserEvent {
  const FetchCurrentUser();

  @override
  List<Object> get props => [];
}
