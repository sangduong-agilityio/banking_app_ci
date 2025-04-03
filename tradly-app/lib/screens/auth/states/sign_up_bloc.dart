import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/repositories/auth_repo.dart';
import 'package:tradly_app/utils/enumeration.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(
          SignUpState(
            viewState: SubmissionStatus.initial,
          ),
        ) {
    on<SignUpSubmitEvent>(_onSignUpSubmitted);
    on<SignUpFormValidateChanged>(_onFormValidateChanged);
  }

  final AuthRepository _authRepository;

  Future<void> _onSignUpSubmitted(
    SignUpSubmitEvent event,
    Emitter<SignUpState> emit,
  ) async {
    emit(
      state.copyWith(
        viewState: SubmissionStatus.loading,
      ),
    );
    try {
      final response = await _authRepository.signUp(
        email: event.email,
        password: event.password,
        username: event.username,
      );
      if (response.user != null) {
        emit(
          state.copyWith(
            viewState: SubmissionStatus.successful,
          ),
        );
      } else {
        emit(
          state.copyWith(
            viewState: SubmissionStatus.failed,
            message: 'Sign-up failed',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          viewState: SubmissionStatus.failed,
          message: e.toString(),
        ),
      );
    }
  }

  void _onFormValidateChanged(
    SignUpFormValidateChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      state.copyWith(
        isFormValid: event.isFormValid,
        username: event.username ?? state.username,
        email: event.email ?? state.email,
        password: event.password ?? state.password,
        passwordConfirm: event.confirmPassword ?? state.passwordConfirm,
      ),
    );
  }
}
