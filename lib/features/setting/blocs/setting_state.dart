import 'package:banking_app/features/setting/models/user_model.dart';
import 'package:banking_app/core/services/biometric_capability.dart';
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
    this.biometricCapability = BiometricCapability.none,
  });

  final UserModel? user;
  final SettingStatus status;
  final String? errorMessage;
  final bool isBiometricEnabled;
  final bool isBiometricAvailable;
  final bool hasSavedBiometricCredentials;
  final BiometricCapability biometricCapability;

  SettingState copyWith({
    UserModel? user,
    SettingStatus? status,
    String? errorMessage,
    bool? isBiometricEnabled,
    bool? isBiometricAvailable,
    bool? hasSavedBiometricCredentials,
    BiometricCapability? biometricCapability,
  }) {
    return SettingState(
      user: user ?? this.user,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
      hasSavedBiometricCredentials:
          hasSavedBiometricCredentials ?? this.hasSavedBiometricCredentials,
      biometricCapability: biometricCapability ?? this.biometricCapability,
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
    biometricCapability,
  ];
}

@freezed
sealed class SettingStatus with _$SettingStatus {
  const factory SettingStatus.initial() = SettingStatusInitial;
  const factory SettingStatus.loading() = SettingStatusLoading;
  const factory SettingStatus.success() = SettingStatusSuccess;
  const factory SettingStatus.failure() = SettingStatusFailure;
}
