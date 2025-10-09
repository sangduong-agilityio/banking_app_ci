import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

/// State class for authentication, managing various aspects of the auth process.
class AuthState extends Equatable {
  /// Creates an [AuthState] object.
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

  /// The current status of the authentication process.
  final AuthStatus status;

  /// The username entered by the user.
  final String username;

  /// The email entered by the user.
  final String email;

  /// The password entered by the user.
  final String password;

  /// Whether the sign-in or sign-up form is valid.
  final bool isFormValid;

  /// Whether the user has accepted the terms and conditions.
  final bool isTermsAccepted;

  /// An error message to display to the user.
  final String? errorMessage;

  /// The session token for the authenticated user.
  final String? sessionToken;

  /// Whether biometric authentication is available on the device.
  final bool isBiometricAvailable;

  /// Whether the user has enabled biometric authentication.
  final bool isBiometricEnabled;

  /// Whether the user has saved their credentials for biometric authentication.
  final bool hasSavedBiometricCredentials;

  /// Creates a copy of the current [AuthState] with the given fields replaced
  /// with the new values.
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

/// Represents the status of the authentication process.
@freezed
sealed class AuthStatus with _$AuthStatus {
  /// The initial status.
  const factory AuthStatus.initial() = AuthStatusInitial;

  /// The loading status.
  const factory AuthStatus.loading() = AuthStatusLoading;

  /// The success status.
  const factory AuthStatus.success() = AuthStatusSuccess;

  /// The failure status.
  const factory AuthStatus.failure() = AuthStatusFailure;
}
