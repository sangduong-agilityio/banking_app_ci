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
    this.phoneNumber,
  });
  final bool isValidate;
  final String? email;
  final String? password;
  final String? phoneNumber;

  @override
  List<Object?> get props => [
        email,
        password,
        isValidate,
        phoneNumber,
      ];
}

class SendOtpFormValidateChangedevt extends SignInEvt {
  const SendOtpFormValidateChangedevt({
    required this.isValidate,
    this.phoneNumber,
  });
  final bool isValidate;
  final String? phoneNumber;

  @override
  List<Object?> get props => [
        phoneNumber,
        isValidate,
      ];
}

class SignInButtonPressedEvt extends SignInEvt {
  const SignInButtonPressedEvt();

  @override
  List<Object?> get props => [];
}

class SendOtpButtonPressedEvt extends SignInEvt {
  const SendOtpButtonPressedEvt({
    required this.phoneNumber,
  });

  final String phoneNumber;

  @override
  List<Object?> get props => [phoneNumber];
}
