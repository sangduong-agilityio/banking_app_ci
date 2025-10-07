import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:banking_app/features/auth/states/auth_event.dart';
import 'package:banking_app/features/auth/states/auth_state.dart';
import 'package:banking_app/features/auth/repositories/auth_repository.dart';
import 'package:banking_app/core/services/biometric_service.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/security/error_sanitizer.dart';

class AuthBloc extends Bloc<AuthEvt, AuthState> {
  AuthBloc({required this.repo, required this.biometricService})
    : super(const AuthState()) {
    on<SignInFormValidateChangedEvt>(_onSignInFormValidateChanged);
    on<SignInButtonPressedEvt>(_onSignInPressed);
    on<SignInWithBiometricEvt>(_onSignInWithBiometric);
    on<CheckBiometricAvailabilityEvt>(_onCheckBiometricAvailability);
    on<SignUpFormValidateChangedEvt>(_onSignUpFormValidateChanged);
    on<SignUpButtonPressedEvt>(_onSignUpPressed);
    on<SignUpTermsChangedEvt>(_onSignUpTermsChanged);
  }

  final AuthRepository repo;
  final BiometricService biometricService;

  Future<void> _onSignInFormValidateChanged(
    SignInFormValidateChangedEvt event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        isFormValid: event.isValidate,
        email: event.email,
        password: event.password,
      ),
    );
  }

  Future<void> _onSignInPressed(
    SignInButtonPressedEvt event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: const AuthStatus.loading()));
    try {
      final response = await repo.signIn(
        email: state.email,
        password: state.password,
      );

      if (response.user != null && response.session != null) {
        emit(
          state.copyWith(
            status: const AuthStatus.success(),
            sessionToken: response.session?.accessToken,
            errorMessage: '',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: const AuthStatus.failure(),
            errorMessage: S.current.authErrorLoginFailed,
          ),
        );
      }
    } catch (e, stackTrace) {
      // ✅ IMPROVED: Add isCritical flag and better context
      await ErrorSanitizer.logSecureError(
        e,
        stackTrace,
        userId: state.email,
        context: {
          'action': 'sign_in',
          'email_domain': state.email.split('@').lastOrNull ?? 'unknown',
          'has_password': state.password.isNotEmpty,
          'form_valid': state.isFormValid,
        },
        isCritical: false, // Login failures are expected, not critical
      );

      emit(
        state.copyWith(
          status: const AuthStatus.failure(),
          errorMessage: ErrorSanitizer.sanitize(e),
        ),
      );
    }
  }

  Future<void> _onSignInWithBiometric(
    SignInWithBiometricEvt event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: const AuthStatus.loading()));
    try {
      final canLogin = await biometricService.canLoginWithBiometrics();
      if (!canLogin) {
        emit(
          state.copyWith(
            status: const AuthStatus.failure(),
            errorMessage: S.current.authErrorBiometricNotEnabled,
          ),
        );
        return;
      }

      final token = await biometricService.loginWithBiometrics();
      if (token == null) {
        emit(
          state.copyWith(
            status: const AuthStatus.failure(),
            errorMessage: S.current.authErrorBiometricFailed,
          ),
        );
        return;
      }

      final response = await repo.setSession(token);
      if (response.user != null && response.session != null) {
        emit(
          state.copyWith(
            status: const AuthStatus.success(),
            sessionToken: response.session?.accessToken,
            errorMessage: '',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: const AuthStatus.failure(),
            errorMessage: S.current.authErrorNoSavedCredentials,
          ),
        );
      }
    } catch (e, stackTrace) {
      // Log biometric sign-in errors with context
      await ErrorSanitizer.logSecureError(
        e,
        stackTrace,
        context: {
          'action': 'biometric_sign_in',
          'biometric_available': state.isBiometricAvailable,
          'biometric_enabled': state.isBiometricEnabled,
          'has_saved_credentials': state.hasSavedBiometricCredentials,
        },
        // Biometric system failures are critical
        isCritical: true,
      );

      emit(
        state.copyWith(
          status: const AuthStatus.failure(),
          errorMessage: S.current.authErrorUnknown,
        ),
      );
    }
  }

  Future<void> _onCheckBiometricAvailability(
    CheckBiometricAvailabilityEvt event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final available = await biometricService.canCheckBiometrics();
      final enabled = await biometricService.isBiometricEnabled();
      final token = await biometricService.getRefreshToken();

      final hasSaved = enabled && token != null;

      emit(
        state.copyWith(
          isBiometricAvailable: available,
          isBiometricEnabled: enabled,
          hasSavedBiometricCredentials: hasSaved,
        ),
      );
    } catch (e, stackTrace) {
      // Log biometric check errors
      await ErrorSanitizer.logSecureError(
        e,
        stackTrace,
        context: {'action': 'check_biometric_availability'},
        // Check failures are not critical
        isCritical: false,
      );

      // Don't show error to user, just disable biometric
      emit(
        state.copyWith(
          isBiometricAvailable: false,
          isBiometricEnabled: false,
          hasSavedBiometricCredentials: false,
        ),
      );
    }
  }

  Future<void> _onSignUpPressed(
    SignUpButtonPressedEvt event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: const AuthStatus.loading()));
    try {
      final response = await repo.signUp(
        email: state.email,
        password: state.password,
        username: state.username,
      );

      emit(
        state.copyWith(
          status: response.user != null
              ? const AuthStatus.success()
              : const AuthStatus.failure(),
          errorMessage: response.user != null
              ? ''
              : S.current.authErrorLoginFailed,
        ),
      );
    } catch (e, stackTrace) {
      // Log sign up errors (was missing before!)
      await ErrorSanitizer.logSecureError(
        e,
        stackTrace,
        userId: state.email,
        context: {
          'action': 'sign_up',
          'email_domain': state.email.split('@').lastOrNull ?? 'unknown',
          'has_username': state.username.isNotEmpty,
          'terms_accepted': state.isTermsAccepted,
        },
        // Sign up failures are expected
        isCritical: false,
      );

      emit(
        state.copyWith(
          status: const AuthStatus.failure(),
          errorMessage: ErrorSanitizer.sanitize(e),
        ),
      );
    }
  }

  Future<void> _onSignUpTermsChanged(
    SignUpTermsChangedEvt event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isTermsAccepted: event.isAccepted));
  }

  Future<void> _onSignUpFormValidateChanged(
    SignUpFormValidateChangedEvt event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        isFormValid: event.isValidate,
        username: event.username,
        email: event.email,
        password: event.password,
      ),
    );
  }
}
