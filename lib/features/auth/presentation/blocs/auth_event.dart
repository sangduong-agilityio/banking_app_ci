part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInFormValidateChanged extends AuthEvent {
  const SignInFormValidateChanged({
    required this.isValidate,
    this.email,
    this.password,
  });

  final bool isValidate;
  final String? email;
  final String? password;

  @override
  List<Object?> get props => [isValidate, email, password];
}

class SignInButtonPressed extends AuthEvent {}

class SignInWithBiometric extends AuthEvent {}

class CheckBiometricAvailability extends AuthEvent {}

class SignUpFormValidateChanged extends AuthEvent {
  const SignUpFormValidateChanged({
    required this.isValidate,
    this.username,
    this.email,
    this.password,
  });

  final bool isValidate;
  final String? username;
  final String? email;
  final String? password;

  @override
  List<Object?> get props => [isValidate, username, email, password];
}

class SignUpButtonPressed extends AuthEvent {}

class SignUpTermsChanged extends AuthEvent {
  const SignUpTermsChanged({required this.isAccepted});

  final bool isAccepted;

  @override
  List<Object> get props => [isAccepted];
}

class GetCurrentUser extends AuthEvent {}
