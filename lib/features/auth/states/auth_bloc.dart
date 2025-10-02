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

  // Update state when the sign-in form changes
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

  // Handle sign-in button pressed
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
    } catch (e) {
      emit(
        state.copyWith(
          status: const AuthStatus.failure(),
          errorMessage: ErrorSanitizer.sanitize(e),
        ),
      );
    }
  }

  // Handle biometric login
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
    } catch (_) {
      emit(
        state.copyWith(
          status: const AuthStatus.failure(),
          errorMessage: S.current.authErrorUnknown,
        ),
      );
    }
  }

  // Check biometric availability and saved credentials
  Future<void> _onCheckBiometricAvailability(
    CheckBiometricAvailabilityEvt event,
    Emitter<AuthState> emit,
  ) async {
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
  }

  // Handle sign-up button pressed
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
              ? AuthStatus.success()
              : AuthStatus.failure(),
          errorMessage: response.user != null
              ? ''
              : S.current.authErrorLoginFailed,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure(),
          errorMessage: S.current.authErrorUnknown,
        ),
      );
    }
  }

  // Handle changes to sign-up terms acceptance
  Future<void> _onSignUpTermsChanged(
    SignUpTermsChangedEvt event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isTermsAccepted: event.isAccepted));
  }

  // Handle sign-up form validation changes
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
