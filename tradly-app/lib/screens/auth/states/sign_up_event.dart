import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {}

class SignUpSubmitEvent extends SignUpEvent {
  SignUpSubmitEvent({
    required this.username,
    required this.password,
    required this.email,
  });
  final String username;
  final String password;
  final String email;

  @override
  List<Object?> get props => [username, email, password];
}

class SignUpFormValidateChanged extends SignUpEvent {
  SignUpFormValidateChanged({
    required this.isFormValid,
    this.password,
    this.username,
    this.email,
    this.confirmPassword,
  });

  final bool isFormValid;
  final String? username;
  final String? email;
  final String? password;
  final String? confirmPassword;

  @override
  List<Object?> get props => [
        isFormValid,
        username,
        email,
        password,
        confirmPassword,
      ];
}
