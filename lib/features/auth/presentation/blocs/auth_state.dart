import 'package:equatable/equatable.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
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
    this.previousState,
    this.isOptimistic = false,
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

  /// Snapshot of the previous state for rollback on optimistic update failure
  final AuthState? previousState;

  /// Indicates if this state is an optimistic update
  final bool isOptimistic;

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
    previousState,
    isOptimistic,
  ];

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
    AuthState? previousState,
    bool? isOptimistic,
    bool clearPreviousState = false,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      isFormValid: isFormValid ?? this.isFormValid,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      sessionToken: sessionToken ?? this.sessionToken,
      isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      hasSavedBiometricCredentials:
          hasSavedBiometricCredentials ?? this.hasSavedBiometricCredentials,
      previousState: clearPreviousState
          ? null
          : (previousState ?? this.previousState),
      isOptimistic: isOptimistic ?? this.isOptimistic,
    );
  }

  /// Creates an optimistic state with a snapshot of the current state
  AuthState toOptimistic({
    required AuthStatus status,
    String? username,
    String? sessionToken,
  }) {
    return AuthState(
      status: status,
      username: username ?? this.username,
      email: email,
      password: password,
      isFormValid: isFormValid,
      isTermsAccepted: isTermsAccepted,
      errorMessage: null,
      sessionToken: sessionToken ?? this.sessionToken,
      isBiometricAvailable: isBiometricAvailable,
      isBiometricEnabled: isBiometricEnabled,
      hasSavedBiometricCredentials: hasSavedBiometricCredentials,
      previousState: this,
      isOptimistic: true,
    );
  }

  /// Rolls back to the previous state with an error message
  AuthState rollback({required String errorMessage}) {
    if (previousState != null) {
      return previousState!.copyWith(
        status: AuthStatus.failure,
        errorMessage: errorMessage,
        clearPreviousState: true,
        isOptimistic: false,
      );
    }
    return copyWith(
      status: AuthStatus.failure,
      errorMessage: errorMessage,
      clearPreviousState: true,
      isOptimistic: false,
    );
  }

  /// Confirms the optimistic update with real data
  AuthState confirm({String? sessionToken, String? username}) {
    return copyWith(
      status: AuthStatus.success,
      sessionToken: sessionToken ?? this.sessionToken,
      username: username ?? this.username,
      clearPreviousState: true,
      clearError: true,
      isOptimistic: false,
    );
  }
}
