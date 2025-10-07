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
    this.isTermsAccepted = false,
    this.errorMessage,
    this.sessionToken,
    this.isBiometricAvailable = false,
    this.isBiometricEnabled = false,
    this.hasSavedBiometricCredentials = false,
  });

  final AuthStatus status;
  final String username;
  final String email;
  final String password;
  final bool isFormValid;
  final bool isTermsAccepted;
  final String? errorMessage;
  final String? sessionToken;
  final bool isBiometricAvailable;
  final bool isBiometricEnabled;
  final bool hasSavedBiometricCredentials;

  AuthState copyWith({
    AuthStatus? status,
    String? username,
    String? email,
    String? password,
    bool? isFormValid,
    bool? isTermsAccepted,
    String? sessionToken,
    String? errorMessage,
    bool? isBiometricAvailable,
    bool? isBiometricEnabled,
    bool? hasSavedBiometricCredentials,
  }) {
    return AuthState(
      status: status ?? this.status,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      isFormValid: isFormValid ?? this.isFormValid,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
      errorMessage: errorMessage ?? this.errorMessage,
      sessionToken: sessionToken ?? this.sessionToken,
      isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      hasSavedBiometricCredentials:
          hasSavedBiometricCredentials ?? this.hasSavedBiometricCredentials,
    );
  }

  @override
  List<Object?> get props => [
    status,
    username,
    email,
    password,
    isFormValid,
    isTermsAccepted,
    errorMessage,
    sessionToken,
    isBiometricAvailable,
    isBiometricEnabled,
    hasSavedBiometricCredentials,
  ];
}

@freezed
sealed class AuthStatus with _$AuthStatus {
  const factory AuthStatus.initial() = AuthStatusInitial;
  const factory AuthStatus.loading() = AuthStatusLoading;
  const factory AuthStatus.success() = AuthStatusSuccess;
  const factory AuthStatus.failure() = AuthStatusFailure;
}
