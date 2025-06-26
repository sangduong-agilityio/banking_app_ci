import 'package:equatable/equatable.dart';

class SignUpEvt extends Equatable {
  const SignUpEvt();

  @override
  List<Object?> get props => [];
}

class SignUpFormValidateChangedEvt extends SignUpEvt {
  const SignUpFormValidateChangedEvt({
    required this.isValidate,
    this.username,
    this.emailOrPhoneNumber,
    this.password,
    this.confirmPassword,
  });

  final bool isValidate;
  final String? username;
  final String? emailOrPhoneNumber;
  final String? password;
  final String? confirmPassword;

  @override
  List<Object?> get props => [
        isValidate,
        username,
        emailOrPhoneNumber,
        password,
        confirmPassword,
      ];
}

class SignUpButtonPressedEvt extends SignUpEvt {
  const SignUpButtonPressedEvt();

  @override
  List<Object?> get props => [];
}
