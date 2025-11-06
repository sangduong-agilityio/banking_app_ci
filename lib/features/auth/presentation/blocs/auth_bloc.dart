import 'package:banking_app/features/auth/presentation/blocs/auth_state.dart';
import 'package:bloc/bloc.dart';
import 'package:banking_app/features/auth/data/repositories/auth_repository.dart';
import 'package:banking_app/core/data/services/biometric_service.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/error_handling/error_sanitizer.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:banking_app/core/common/utils/pref_keys.dart';

part 'auth_event.dart';

/// Bloc for handling authentication events and states.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.repo,
    required this.biometricService,
    required this.prefs,
  }) : super(const AuthState()) {
    on<SignInFormValidateChanged>(_onSignInFormValidateChanged);
    on<SignInButtonPressed>(_onSignInPressed);
    on<SignInWithBiometric>(_onSignInWithBiometric);
    on<CheckBiometricAvailability>(_onCheckBiometricAvailability);
    on<SignUpFormValidateChanged>(_onSignUpFormValidateChanged);
    on<SignUpButtonPressed>(_onSignUpPressed);
    on<SignUpTermsChanged>(_onSignUpTermsChanged);
    on<GetCurrentUser>(_onGetCurrentUser);
  }

  final AuthRepository repo;
  final BiometricService biometricService;
  final SharedPreferences prefs;

  void _onSignInFormValidateChanged(
    SignInFormValidateChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(
      state.copyWith(
        isFormValid: event.isValidate,
        email: event.email ??'',
        password: event.password ??'',
      ),
    );
  }

  Future<void> _onSignInPressed(
    SignInButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final response = await repo.signIn(
        email: state.email,
        password: state.password,
      );

      if (response.user != null && response.session != null) {
        await prefs.setString(
          PrefKeys.sessionToken,
          response.session?.accessToken ?? '',
        );
        emit(
          state.copyWith(
            status: AuthStatus.success,
            sessionToken: response.session?.accessToken,
            errorMessage: '',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: S.current.authErrorLoginFailed,
          ),
        );
      }
    } catch (e, stackTrace) {
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
        isCritical: false,
      );

      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: ErrorSanitizer.sanitize(e),
        ),
      );
    }
  }

  Future<void> _onSignInWithBiometric(
    SignInWithBiometric event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final canLogin = await biometricService.canLoginWithBiometrics();
      if (!canLogin) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: S.current.authErrorBiometricNotEnabled,
          ),
        );
        return;
      }

      final token = await biometricService.loginWithBiometrics();
      if (token == null) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: S.current.authErrorBiometricFailed,
          ),
        );
        return;
      }

      final response = await repo.setSession(token);
      if (response.user != null && response.session != null) {
        await prefs.setString(
          PrefKeys.sessionToken,
          response.session?.accessToken ?? '',
        );
        emit(
          state.copyWith(
            status: AuthStatus.success,
            sessionToken: response.session?.accessToken,
            errorMessage: '',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: S.current.authErrorNoSavedCredentials,
          ),
        );
      }
    } catch (e, stackTrace) {
      await ErrorSanitizer.logSecureError(
        e,
        stackTrace,
        context: {
          'action': 'biometric_sign_in',
          'biometric_available': state.isBiometricAvailable,
          'biometric_enabled': state.isBiometricEnabled,
          'has_saved_credentials': state.hasSavedBiometricCredentials,
        },
        isCritical: true,
      );

      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: S.current.authErrorUnknown,
        ),
      );
    }
  }

  Future<void> _onCheckBiometricAvailability(
    CheckBiometricAvailability event,
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
      await ErrorSanitizer.logSecureError(
        e,
        stackTrace,
        context: {'action': 'check_biometric_availability'},
        isCritical: false,
      );

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
    SignUpButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final response = await repo.signUp(
        email: state.email,
        password: state.password,
        username: state.username,
      );

      if (response.user != null) {
        await repo.createUserProfile(
          userId: response.user!.id,
          username: state.username,
          email: state.email,
        );
        emit(
          state.copyWith(status: AuthStatus.success, errorMessage: ''),
        );
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: S.current.authErrorSignupFailed,
          ),
        );
      }
    } catch (e, stackTrace) {
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
        isCritical: false,
      );

      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: ErrorSanitizer.sanitize(e),
        ),
      );
    }
  }

  void _onSignUpTermsChanged(
    SignUpTermsChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(isTermsAccepted: event.isAccepted));
  }

  void _onSignUpFormValidateChanged(
    SignUpFormValidateChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(
      state.copyWith(
        isFormValid: event.isValidate,
        username: event.username ?? '',
        email: event.email ?? '',
        password: event.password ?? '',
      ),
    );
  }

  Future<void> _onGetCurrentUser(
    GetCurrentUser event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = repo.getCurrentUser();
      if (user != null) {
        final username = user.userMetadata?['username'] as String?;
        if (username != null) {
          emit(state.copyWith(username: username));
        }
      }
    } catch (e, stackTrace) {
      await ErrorSanitizer.logSecureError(
        e,
        stackTrace,
        context: {'action': 'get_current_user'},
        isCritical: false,
      );
    }
  }
}
