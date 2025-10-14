import 'dart:io';

/// An enum that represents the biometric capabilities of a device.
enum BiometricCapability { none, available, touchId, faceId, fingerprint }

/// An extension on the [BiometricCapability] enum to provide user-friendly display names, labels, and messages.
extension BiometricCapabilityExtension on BiometricCapability {
  /// Returns a user-friendly display name for the biometric capability.
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

  /// Returns a user-friendly label for enabling biometric authentication in settings.
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

  /// Returns a message indicating that biometric authentication has been enabled.
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

  /// Returns a message indicating that biometric authentication has been disabled.
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

  /// Returns whether biometric authentication is available on the device.
  bool get isAvailable => this != BiometricCapability.none;
}
