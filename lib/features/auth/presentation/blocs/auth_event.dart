import 'package:equatable/equatable.dart';

/// Base class for all authentication events.
/// Extends [Equatable] to enable value comparison.
class AuthEvt extends Equatable {
  const AuthEvt();

  @override
  List<Object?> get props => [];
}

/// Event triggered when the sign-in form validation state changes.
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

/// Event triggered when the sign-in button is pressed.
class SignInButtonPressedEvt extends AuthEvt {
  const SignInButtonPressedEvt();

  @override
  List<Object?> get props => [];
}

/// Event triggered to initiate biometric sign-in.
class SignInWithBiometricEvt extends AuthEvt {
  const SignInWithBiometricEvt();

  @override
  List<Object?> get props => [];
}

/// Event triggered to check biometric availability.
class CheckBiometricAvailabilityEvt extends AuthEvt {
  const CheckBiometricAvailabilityEvt();

  @override
  List<Object?> get props => [];
}

/// Event triggered when the sign-up form validation state changes.
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

/// Event triggered when the sign-up button is pressed.
class SignUpButtonPressedEvt extends AuthEvt {
  const SignUpButtonPressedEvt();

  @override
  List<Object?> get props => [];
}

/// Event triggered when the terms acceptance state changes during sign-up.
class SignUpTermsChangedEvt extends AuthEvt {
  const SignUpTermsChangedEvt({required this.isAccepted});

  final bool isAccepted;

  @override
  List<Object?> get props => [isAccepted];
}

/// Event triggered to get the current user.
class GetCurrentUserEvt extends AuthEvt {
  const GetCurrentUserEvt();

  @override
  List<Object?> get props => [];
}
