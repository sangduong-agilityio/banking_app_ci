import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInSubmitted extends SignInEvent {
  final String email;
  final String password;

  SignInSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignInFormValidateChanged extends SignInEvent {
  final bool isValid;
  final String? email;
  final String? password;

  SignInFormValidateChanged({
    required this.isValid,
    this.email,
    this.password,
  });

  @override
  List<Object?> get props => [isValid, email, password];
}

class SignInButtonPressed extends SignInEvent {
  final String email;
  final String password;

  SignInButtonPressed({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
