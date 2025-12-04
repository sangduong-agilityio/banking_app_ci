import 'package:equatable/equatable.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsersEvent extends UsersEvent {
  const LoadUsersEvent();
}

class AddUserEvent extends UsersEvent {
  final String name;
  final String email;

  const AddUserEvent({required this.name, required this.email});

  @override
  List<Object?> get props => [name, email];
}

class UpdateUserEvent extends UsersEvent {
  final String id;
  final String? name;
  final String? email;

  const UpdateUserEvent({required this.id, this.name, this.email});

  @override
  List<Object?> get props => [id, name, email];
}

class DeleteUserEvent extends UsersEvent {
  final String id;

  const DeleteUserEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Event to reset the state (clear success/error messages)
class ResetUsersStateEvent extends UsersEvent {
  const ResetUsersStateEvent();
}
