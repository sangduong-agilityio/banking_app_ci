import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_state.freezed.dart';

class SignInState extends Equatable {
  const SignInState({
    this.status = const SignInStatus.initial(),
    this.email = '',
    this.password = '',
    this.phoneNumber = '',
    this.isFormValid = false,
    this.errorMessage,
    this.sessionToken,
  });

  final SignInStatus status;
  final String email;
  final String password;
  final String? phoneNumber;
  final bool isFormValid;
  final String? errorMessage;
  final String? sessionToken;

  SignInState copyWith({
    SignInStatus? status,
    String? errorMessage,
    bool? isFormValid,
    String? email,
    String? password,
    String? phoneNumber,
    String? sessionToken,
  }) {
    return SignInState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormValid: isFormValid ?? this.isFormValid,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      sessionToken: sessionToken ?? this.sessionToken,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        isFormValid,
        email,
        password,
        phoneNumber,
        sessionToken,
      ];
}

@freezed
sealed class SignInStatus with _$SignInStatus {
  const factory SignInStatus.initial() = SignInStatusInitial;
  const factory SignInStatus.loading() = SignInStatusLoading;
  const factory SignInStatus.success() = SignInStatusSuccess;
  const factory SignInStatus.failure() = SignInStatusFailure;
}
