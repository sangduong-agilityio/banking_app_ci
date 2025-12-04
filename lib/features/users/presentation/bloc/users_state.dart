import 'package:banking_app/features/users/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'users_state.freezed.dart';

class UsersState extends Equatable {
  /// Current status of the users feature
  final UsersStatus status;

  /// List of users fetched from GraphQL
  final List<UserEntity> users;

  /// Error message if something went wrong
  final String? errorMessage;

  /// Success message for user feedback
  final String? successMessage;

  const UsersState({
    this.status = const UsersStatus.initial(),
    this.users = const [],
    this.errorMessage,
    this.successMessage,
  });

  /// Create a copy with modified fields
  UsersState copyWith({
    UsersStatus? status,
    List<UserEntity>? users,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return UsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }

  /// Check if loading
  bool get isLoading => status is UsersStatusLoading;

  /// Check if has error
  bool get hasError => status is UsersStatusFailure;

  /// Check if successful
  bool get isSuccess => status is UsersStatusSuccess;

  @override
  List<Object?> get props => [status, users, errorMessage, successMessage];
}

@freezed
sealed class UsersStatus with _$UsersStatus {
  /// Initial state before any action
  const factory UsersStatus.initial() = UsersStatusInitial;

  /// Loading state while fetching/mutating data
  const factory UsersStatus.loading() = UsersStatusLoading;

  /// Success state after successful operation
  const factory UsersStatus.success() = UsersStatusSuccess;

  /// Failure state when an error occurs
  const factory UsersStatus.failure() = UsersStatusFailure;
}
