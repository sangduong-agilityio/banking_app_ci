import 'package:banking_app/features/auth/bloc/auth_event.dart';
import 'package:banking_app/features/auth/bloc/auth_state.dart';
import 'package:banking_app/features/auth/services/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvt, AuthState> {
  AuthBloc({required this.authRepository}) : super(const AuthState()) {
    on<SignInFormValidateChangedEvt>(_onSignInFormValidateChanged);
    on<SignInButtonPressedEvt>(_onLoginPressed);
    on<SignUpFormValidateChangedEvt>(_onSignUpFormValidateChanged);
    on<SignUpButtonPressedEvt>(_onSignUpPressed);
  }

  final AuthRepository authRepository;

  Future<void> _onSignInFormValidateChanged(
    SignInFormValidateChangedEvt event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        isFormValid: event.isValidate,
        password: event.password,
        email: event.email,
      ),
    );
  }

  Future<void> _onLoginPressed(
    SignInButtonPressedEvt event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: const AuthStatus.loading()));

    try {
      final response = await authRepository.signIn(
        email: state.email,
        password: state.password,
      );

      emit(
        state.copyWith(
          status: response.user != null && response.session != null
              ? AuthStatus.success()
              : AuthStatus.failure(),
          errorMessage: response.user != null ? '' : 'Login failed',
          // sessionToken: response.session?.accessToken,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
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

  Future<void> _onSignUpPressed(
    SignUpButtonPressedEvt event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: const AuthStatus.loading()));
    try {
      final response = await authRepository.signUp(
        email: state.email,
        password: state.password,
        username: state.username,
      );
      emit(
        state.copyWith(
          status: response.user != null
              ? AuthStatus.success()
              : AuthStatus.failure(),
          errorMessage: response.user != null ? '' : 'Sign-up failed',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
