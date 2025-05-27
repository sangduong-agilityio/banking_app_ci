import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/data/repositories/auth_repo.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvt, SignUpState> {
  final AuthRepository authRepository;

  SignUpBloc({required this.authRepository}) : super(const SignUpState()) {
    on<SignUpFormValidateChangedEvt>(_onFormValidateChanged);
    on<SignUpButtonPressedEvt>(_onSignUpPressed);
  }

  void _onFormValidateChanged(
    SignUpFormValidateChangedEvt event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      state.copyWith(
        isFormValid: event.isValidate,
        username: event.username,
        emailOrPhoneNumber: event.emailOrPhoneNumber,
        password: event.password,
        confirmPassword: event.confirmPassword,
      ),
    );
  }

  Future<void> _onSignUpPressed(
    SignUpButtonPressedEvt event,
    Emitter<SignUpState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const SignUpStatus.loading(),
      ),
    );
    try {
      final response = await authRepository.signUp(
        emailOrPhoneNumber: state.emailOrPhoneNumber,
        password: state.password,
        username: state.username,
      );
      emit(
        state.copyWith(
          status: response.user != null
              ? SignUpStatus.success()
              : SignUpStatus.failure(),
          errorMessage: response.user != null ? '' : 'Sign-up failed',
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: SignUpStatus.failure(),
        errorMessage: e.toString(),
      ));
    }
  }
}
