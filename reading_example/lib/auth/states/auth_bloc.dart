import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reading_example/auth/states/auth_event.dart';
import 'package:reading_example/auth/states/auth_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<CheckLoginSession>(_onCheckLoginSession); // Event to check login session
    on<LoginButtonPressed>(_onLoginButtonPressed); // Event to handle login
  }

  // Handle the CheckLoginSession event
  Future<void> _onCheckLoginSession(
      CheckLoginSession event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      bool isLoggedIn = await _checkIfUserIsLoggedIn();
      if (isLoggedIn) {
        emit(LoginSessionActive());
      } else {
        emit(LoginSessionInactive());
      }
    } catch (error) {
      emit(LoginFailure(
          error: 'An error occurred while checking login session.'));
    }
  }

  // Simulate checking if the user is logged in (e.g., by checking shared preferences or a token)
  Future<bool> _checkIfUserIsLoggedIn() async {
    return Future.value(true); // Assume the user is logged in
  }

  // Handle the login button press event
  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      // Simulate a login attempt (e.g., API call to authenticate the user)
      await Future.delayed(Duration(seconds: 2));
      if (event.username == 'user' && event.password == 'password') {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure(error: 'Invalid credentials'));
      }
    } catch (e) {
      emit(LoginFailure(error: 'An error occurred while logging in.'));
    }
  }
}
