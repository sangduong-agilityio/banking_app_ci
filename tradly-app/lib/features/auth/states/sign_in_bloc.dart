import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/features/auth/repositories/auth_repo.dart';
import 'sign_in_event.dart';

import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvt, SignInState> {
  final AuthRepository authRepository;

  SignInBloc({required this.authRepository}) : super(const SignInState()) {
    on<SignInFormValidateChangedEvt>(_onFormValidateChanged);
    on<SignInButtonPressedEvt>(_onLoginPressed);
  }

  Future<void> _onFormValidateChanged(
    SignInFormValidateChangedEvt event,
    Emitter<SignInState> emit,
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
    Emitter<SignInState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const SignInStatus.loading(),
      ),
    );
    try {
      final response = await authRepository.signIn(
        email: state.email,
        password: state.password,
      );
      emit(
        state.copyWith(
          status: response.user != null
              ? SignInStatus.success()
              : SignInStatus.failure(),
          errorMessage: response.user != null ? '' : '',
          sessionToken: response.session?.accessToken,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SignInStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
