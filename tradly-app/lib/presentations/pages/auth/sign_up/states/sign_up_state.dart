import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_state.freezed.dart';

final class SignUpState extends Equatable {
  const SignUpState({
    this.status = const SignUpStatus.initial(),
    this.username = '',
    this.emailOrPhoneNumber = '',
    this.password = '',
    this.confirmPassword = '',
    this.isFormValid = false,
    this.errorMessage,
  });

  final SignUpStatus status;
  final String username;
  final String emailOrPhoneNumber;
  final String password;
  final String confirmPassword;
  final bool isFormValid;
  final String? errorMessage;

  SignUpState copyWith({
    SignUpStatus? status,
    String? username,
    String? emailOrPhoneNumber,
    String? password,
    String? confirmPassword,
    bool? isFormValid,
    String? errorMessage,
  }) {
    return SignUpState(
      status: status ?? this.status,
      username: username ?? this.username,
      emailOrPhoneNumber: emailOrPhoneNumber ?? this.emailOrPhoneNumber,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isFormValid: isFormValid ?? this.isFormValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        username,
        emailOrPhoneNumber,
        password,
        confirmPassword,
        isFormValid,
        errorMessage,
      ];
}

@freezed
sealed class SignUpStatus with _$SignUpStatus {
  const factory SignUpStatus.initial() = SignUpStatusInitial;
  const factory SignUpStatus.loading() = SignUpStatusLoading;
  const factory SignUpStatus.success() = SignUpStatusSuccess;
  const factory SignUpStatus.failure() = SignUpStatusFailure;
}
