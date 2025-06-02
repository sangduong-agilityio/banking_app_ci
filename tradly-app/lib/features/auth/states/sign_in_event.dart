import 'package:equatable/equatable.dart';

sealed class SignInEvt extends Equatable {
  const SignInEvt();

  @override
  List<Object?> get props => [];
}

class SignInFormValidateChangedEvt extends SignInEvt {
  const SignInFormValidateChangedEvt({
    required this.isValidate,
    this.email,
    this.password,
  });
  final bool isValidate;
  final String? email;
  final String? password;

  @override
  List<Object?> get props => [
        email,
        password,
        isValidate,
      ];
}

class SignInButtonPressedEvt extends SignInEvt {
  const SignInButtonPressedEvt();

  @override
  List<Object?> get props => [];
}
