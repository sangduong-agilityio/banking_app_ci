import 'package:banking_app/features/setting/data/models/user_model.dart';
import 'package:banking_app/core/security/biometric_capability.dart';

enum SettingStatus { initial, loading, success, failure }

final class SettingState {
  const SettingState({
    this.user,
    this.status = SettingStatus.initial,
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
}
