import 'package:equatable/equatable.dart';
import 'package:tradly_app/utils/enumeration.dart';

class SignInState extends Equatable {
  const SignInState({
    required this.viewState,
    this.email = '',
    this.password = '',
    this.isFormValid = false,
    this.errorMessage,
  });

  final SubmissionStatus viewState;
  final String email;
  final String password;
  final bool isFormValid;
  final String? errorMessage;

  SignInState copyWith({
    SubmissionStatus? viewState,
    String? errorMessage,
    bool? isFormValid,
    String? email,
    String? password,
  }) {
    return SignInState(
      viewState: viewState ?? this.viewState,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormValid: isFormValid ?? this.isFormValid,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [
        viewState,
        errorMessage,
        isFormValid,
        email,
        password,
      ];
}
