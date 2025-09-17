import 'package:banking_app/features/setting/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_state.freezed.dart';

final class SettingState extends Equatable {
  const SettingState({
    this.user,
    this.status = const SettingStatus.initial(),
    this.errorMessage,
    this.isBiometricEnabled = false,
    this.hasSavedBiometricCredentials = false,
    this.isBiometricAvailable = false,
  });

  final UserModel? user;
  final SettingStatus status;
  final String? errorMessage;
  final bool isBiometricEnabled;
  final bool isBiometricAvailable;
  final bool hasSavedBiometricCredentials;

  SettingState copyWith({
    UserModel? user,
    SettingStatus? status,
    String? errorMessage,
    bool? isBiometricEnabled,
    bool? isBiometricAvailable,
    bool? hasSavedBiometricCredentials,
  }) {
    return SettingState(
      user: user ?? this.user,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
      hasSavedBiometricCredentials:
          hasSavedBiometricCredentials ?? this.hasSavedBiometricCredentials,
    );
  }

  @override
  List<Object?> get props => [
    user,
    status,
    errorMessage,
    isBiometricEnabled,
    hasSavedBiometricCredentials,
    isBiometricAvailable,
  ];
}

@freezed
sealed class SettingStatus with _$SettingStatus {
  const factory SettingStatus.initial() = SettingStatusInitial;
  const factory SettingStatus.loading() = SettingStatusLoading;
  const factory SettingStatus.success() = SettingStatusSuccess;
  const factory SettingStatus.failure() = SettingStatusFailure;
}
