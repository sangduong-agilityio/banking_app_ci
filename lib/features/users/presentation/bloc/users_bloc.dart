import 'package:banking_app/features/users/domain/repositories/users_repository.dart';
import 'package:banking_app/features/users/presentation/bloc/users_event.dart';
import 'package:banking_app/features/users/presentation/bloc/users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersRepository _repository;

  UsersBloc({required UsersRepository repository})
    : _repository = repository,
      super(const UsersState()) {
    // Register event handlers
    on<LoadUsersEvent>(_onLoadUsers);
    on<AddUserEvent>(_onAddUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
    on<ResetUsersStateEvent>(_onResetState);
  }

  Future<void> _onLoadUsers(
    LoadUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    // Show loading indicator
    emit(
      state.copyWith(
        status: const UsersStatus.loading(),
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      // Call repository → GraphQL query
      final users = await _repository.getUsers();

      // Emit success with users data
      emit(state.copyWith(status: const UsersStatus.success(), users: users));
    } catch (e) {
      // Emit failure with error message
      emit(
        state.copyWith(
          status: const UsersStatus.failure(),
          errorMessage: 'Failed to load users: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onAddUser(AddUserEvent event, Emitter<UsersState> emit) async {
    emit(
      state.copyWith(
        status: const UsersStatus.loading(),
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      // Call repository → GraphQL mutation
      final newUser = await _repository.createUser(
        name: event.name,
        email: event.email,
      );

      // Add new user to the list (real-time update)
      final updatedUsers = [...state.users, newUser];

      emit(
        state.copyWith(
          status: const UsersStatus.success(),
          users: updatedUsers,
          successMessage: 'User "${newUser.name}" added successfully!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const UsersStatus.failure(),
          errorMessage: 'Failed to add user: ${e.toString()}',
        ),
      );
    }
  }

  /// Handle UpdateUserEvent
  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const UsersStatus.loading(),
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      final updatedUser = await _repository.updateUser(
        id: event.id,
        name: event.name,
        email: event.email,
      );

      // Update user in the list
      final updatedUsers = state.users.map((user) {
        return user.id == event.id ? updatedUser : user;
      }).toList();

      emit(
        state.copyWith(
          status: const UsersStatus.success(),
          users: updatedUsers,
          successMessage: 'User updated successfully!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const UsersStatus.failure(),
          errorMessage: 'Failed to update user: ${e.toString()}',
        ),
      );
    }
  }

  /// Handle DeleteUserEvent
  Future<void> _onDeleteUser(
    DeleteUserEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const UsersStatus.loading(),
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      final success = await _repository.deleteUser(event.id);

      if (success) {
        // Remove user from the list
        final updatedUsers = state.users
            .where((user) => user.id != event.id)
            .toList();

        emit(
          state.copyWith(
            status: const UsersStatus.success(),
            users: updatedUsers,
            successMessage: 'User deleted successfully!',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: const UsersStatus.failure(),
            errorMessage: 'Failed to delete user',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: const UsersStatus.failure(),
          errorMessage: 'Failed to delete user: ${e.toString()}',
        ),
      );
    }
  }

  /// Handle ResetUsersStateEvent
  void _onResetState(ResetUsersStateEvent event, Emitter<UsersState> emit) {
    emit(
      state.copyWith(
        status: const UsersStatus.initial(),
        clearError: true,
        clearSuccess: true,
      ),
    );
  }
}
