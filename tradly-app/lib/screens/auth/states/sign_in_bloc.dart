import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/repositories/auth_repo.dart';
import 'package:flutter/material.dart'; // Added for debugPrint
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository authRepository;

  SignInBloc({required this.authRepository}) : super(SignInInitial()) {
    on<SignInSubmitted>(_onSignInSubmitted);
    on<SignInFormValidateChanged>(_onFormValidateChanged);
    on<SignInButtonPressed>(_onLoginPressed);
  }

  Future<void> _onSignInSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    debugPrint('SignInSubmitted event received: ${event.email}');
    emit(SignInLoading());
    try {
      final response = await authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      if (response.user != null) {
        debugPrint('Sign-in successful.');
        emit(SignInSuccess());
      } else {
        emit(SignInFailure(error: 'Sign-in failed'));
      }
    } catch (e) {
      debugPrint('Sign-in error: $e');
      emit(SignInFailure(error: e.toString()));
    }
  }

  void _onFormValidateChanged(
    SignInFormValidateChanged event,
    Emitter<SignInState> emit,
  ) {
    if (event.isValid) {
      emit(SignInInitial());
    } else {
      emit(SignInFailure(error: 'Form is invalid'));
    }
  }

  Future<void> _onLoginPressed(
    SignInButtonPressed event,
    Emitter<SignInState> emit,
  ) async {
    emit(SignInLoading());
    try {
      final response = await authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      if (response.user != null) {
        emit(SignInSuccess());
      } else {
        emit(SignInFailure(error: 'Invalid email or password'));
      }
    } catch (e) {
      emit(SignInFailure(error: e.toString()));
    }
  }
}
