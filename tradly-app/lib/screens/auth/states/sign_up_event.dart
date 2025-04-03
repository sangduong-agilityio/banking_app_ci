import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignUpSubmitted extends SignUpEvent {
  final String email;
  final String password;
  final String username;

  SignUpSubmitted({
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        username,
      ];
}

class SignUpFormValidateChanged extends SignUpEvent {
  final bool isValid;

  SignUpFormValidateChanged({
    required this.isValid,
  });

  @override
  List<Object?> get props => [isValid];
}
