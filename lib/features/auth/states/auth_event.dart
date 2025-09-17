import 'package:equatable/equatable.dart';

class AuthEvt extends Equatable {
  const AuthEvt();

  @override
  List<Object?> get props => [];
}

class SignInFormValidateChangedEvt extends AuthEvt {
  const SignInFormValidateChangedEvt({
    required this.isValidate,
    this.email,
    this.password,
  });
  final bool isValidate;
  final String? email;
  final String? password;

  @override
  List<Object?> get props => [email, password, isValidate];
}

class SignInButtonPressedEvt extends AuthEvt {
  const SignInButtonPressedEvt();

  @override
  List<Object?> get props => [];
}

class SignInWithBiometricEvt extends AuthEvt {
  const SignInWithBiometricEvt();

  @override
  List<Object?> get props => [];
}

class CheckBiometricAvailabilityEvt extends AuthEvt {
  const CheckBiometricAvailabilityEvt();

  @override
  List<Object?> get props => [];
}

class SignUpFormValidateChangedEvt extends AuthEvt {
  const SignUpFormValidateChangedEvt({
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

class SignUpButtonPressedEvt extends AuthEvt {
  const SignUpButtonPressedEvt();

  @override
  List<Object?> get props => [];
}

class SignUpTermsChangedEvt extends AuthEvt {
  const SignUpTermsChangedEvt({required this.isAccepted});

  final bool isAccepted;

  @override
  List<Object?> get props => [isAccepted];
}
