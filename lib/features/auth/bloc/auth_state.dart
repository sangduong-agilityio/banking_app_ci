import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

class AuthState extends Equatable {
  const AuthState({
    this.status = const AuthStatus.initial(),
    this.username = '',
    this.email = '',
    this.password = '',
    this.isFormValid = false,
    this.errorMessage,
  });

  final AuthStatus status;
  final String username;
  final String email;
  final String password;
  final bool isFormValid;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    String? username,
    String? email,
    String? password,
    bool? isFormValid,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      isFormValid: isFormValid ?? this.isFormValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    username,
    email,
    password,
    isFormValid,
    errorMessage,
  ];
}

@freezed
sealed class AuthStatus with _$AuthStatus {
  const factory AuthStatus.initial() = AuthStatusInitial;
  const factory AuthStatus.loading() = AuthStatusLoading;
  const factory AuthStatus.success() = AuthStatusSuccess;
  const factory AuthStatus.failure() = AuthStatusFailure;
}
