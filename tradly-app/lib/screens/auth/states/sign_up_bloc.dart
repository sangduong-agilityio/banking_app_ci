import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/repositories/auth_repo.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository;

  SignUpBloc({required this.authRepository}) : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
    on<SignUpFormValidateChanged>(_onFormValidateChanged);
  }

  Future<void> _onSignUpSubmitted(
      SignUpSubmitted event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());
    try {
      final response = await authRepository.signUp(
        email: event.email,
        password: event.password,
        username: event.username,
      );
      if (response.user != null) {
        emit(SignUpSuccess());
      } else {
        emit(SignUpFailure(error: 'Sign-up failed'));
      }
    } catch (e) {
      emit(SignUpFailure(error: e.toString()));
    }
  }

  void _onFormValidateChanged(
      SignUpFormValidateChanged event, Emitter<SignUpState> emit) {
    if (event.isValid) {
      emit(SignUpInitial());
    } else {
      emit(SignUpFailure(error: 'Form is invalid'));
    }
  }
}
