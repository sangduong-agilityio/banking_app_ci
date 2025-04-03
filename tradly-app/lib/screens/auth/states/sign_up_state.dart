import 'package:equatable/equatable.dart';
import 'package:tradly_app/utils/enumeration.dart';

class SignUpState extends Equatable {
  const SignUpState({
    required this.viewState,
    this.username = '',
    this.email = '',
    this.password = '',
    this.passwordConfirm = '',
    this.message = '',
    this.isFormValid = false,
  });
  factory SignUpState.int() {
    return _init ??= const SignUpState(
      viewState: SubmissionStatus.initial,
    );
  }
  final String username;

  final String email;

  final String password;
  final String passwordConfirm;

  final SubmissionStatus viewState;

  final String message;
  final bool isFormValid;

  static SignUpState? _init;

  SignUpState copyWith({
    String? username,
    String? email,
    String? password,
    String? passwordConfirm,
    SubmissionStatus? viewState,
    String? message,
    bool? isFormValid,
  }) {
    return SignUpState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      viewState: viewState ?? this.viewState,
      message: message ?? this.message,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object?> get props => [
        viewState,
        email,
        username,
        password,
        message,
        passwordConfirm,
        isFormValid,
      ];
}
