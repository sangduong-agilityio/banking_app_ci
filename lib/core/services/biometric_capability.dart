import 'dart:io';

enum BiometricCapability { none, available, touchId, faceId, fingerprint }

extension BiometricCapabilityExtension on BiometricCapability {
  String get displayName {
    switch (this) {
      case BiometricCapability.faceId:
        return 'Face ID';
      case BiometricCapability.touchId:
        return 'Touch ID';
      case BiometricCapability.fingerprint:
        return 'Fingerprint';
      case BiometricCapability.available:
        return Platform.isIOS ? 'Biometric ID' : 'Biometric Authentication';
      case BiometricCapability.none:
        return 'Not Available';
    }
  }

  String get settingsLabel {
    switch (this) {
      case BiometricCapability.faceId:
        return 'Enable Face ID';
      case BiometricCapability.touchId:
        return 'Enable Touch ID';
      case BiometricCapability.fingerprint:
        return 'Enable Fingerprint';
      case BiometricCapability.available:
        return 'Enable Biometric Authentication';
      case BiometricCapability.none:
        return 'Biometric Authentication (Not Available)';
    }
  }

  String get enabledMessage {
    switch (this) {
      case BiometricCapability.faceId:
        return 'Face ID has been enabled for secure authentication';
      case BiometricCapability.touchId:
        return 'Touch ID has been enabled for secure authentication';
      case BiometricCapability.fingerprint:
        return 'Fingerprint authentication has been enabled';
      case BiometricCapability.available:
        return 'Biometric authentication has been enabled';
      case BiometricCapability.none:
        return 'Biometric authentication is not available on this device';
    }
  }

  String get disabledMessage {
    switch (this) {
      case BiometricCapability.faceId:
        return 'Face ID has been disabled';
      case BiometricCapability.touchId:
        return 'Touch ID has been disabled';
      case BiometricCapability.fingerprint:
        return 'Fingerprint authentication has been disabled';
      default:
        return 'Biometric authentication has been disabled';
    }
  }

  bool get isAvailable => this != BiometricCapability.none;
}
