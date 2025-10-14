import 'package:banking_app/core/common/utils/pref_keys.dart';
import 'package:banking_app/core/security/biometric_capability.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:io';

/// A service that handles biometric authentication and secure storage of tokens.
class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const _refreshTokenKey = PrefKeys.biometricRefreshToken;
  static const _biometricEnabledKey = PrefKeys.biometricEnabled;

  /// Checks if the device supports biometric authentication.
  Future<bool> canCheckBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  /// Gets a list of available biometric types on the device.
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (_) {
      return <BiometricType>[];
    }
  }

  /// Gets the device-specific biometric capabilities.
  Future<BiometricCapability> getBiometricCapability() async {
    try {
      final isAvailable = await canCheckBiometrics();
      if (!isAvailable) return BiometricCapability.none;

      final availableTypes = await getAvailableBiometrics();
      if (availableTypes.isEmpty) return BiometricCapability.none;

      // Check for Face ID (iOS) or Face authentication (Android)
      if (availableTypes.contains(BiometricType.face)) {
        return BiometricCapability.faceId;
      }

      // Check for Touch ID (iOS) or Fingerprint (Android)
      if (availableTypes.contains(BiometricType.fingerprint)) {
        return BiometricCapability.touchId;
      }

      // Check for other biometric types
      if (availableTypes.contains(BiometricType.iris) ||
          availableTypes.contains(BiometricType.strong) ||
          availableTypes.contains(BiometricType.weak)) {
        return Platform.isIOS
            ? BiometricCapability.touchId
            : BiometricCapability.fingerprint;
      }

      return BiometricCapability.available;
    } catch (_) {
      return BiometricCapability.none;
    }
  }

  /// Gets a user-friendly biometric type name.
  Future<String> getBiometricTypeName() async {
    final capability = await getBiometricCapability();
    return capability.displayName;
  }

  /// Checks if Face ID is available.
  Future<bool> hasFaceId() async {
    final capability = await getBiometricCapability();
    return capability == BiometricCapability.faceId;
  }

  /// Checks if Touch ID or fingerprint is available.
  Future<bool> hasTouchId() async {
    final capability = await getBiometricCapability();
    return capability == BiometricCapability.touchId ||
        capability == BiometricCapability.fingerprint;
  }

  /// Checks if biometric authentication is enabled in the app settings.
  Future<bool> isBiometricEnabled() async {
    final value = await _secureStorage.read(key: _biometricEnabledKey);
    return value == 'true';
  }

  /// Checks if the user can login with biometrics.
  Future<bool> canLoginWithBiometrics() async {
    final canCheck = await canCheckBiometrics();
    final enabled = await isBiometricEnabled();
    final token = await getRefreshToken();
    return canCheck && enabled && token != null;
  }

  /// Checks if biometrics can be used.
  Future<bool> canUseBiometrics() async {
    final available = await getAvailableBiometrics();
    final enabled = await isBiometricEnabled();
    return available.isNotEmpty && enabled;
  }

  /// Authenticates the user using biometrics.
  Future<bool> authenticate({String? customReason}) async {
    try {
      final isAvailable = await _auth.canCheckBiometrics;
      if (!isAvailable) return false;

      final capability = await getBiometricCapability();
      final reason = customReason ?? _getAuthenticationReason(capability);

      final didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      return didAuthenticate;
    } on PlatformException {
      return false;
    }
  }

  /// Gets the default authentication reason based on the biometric capability.
  String _getAuthenticationReason(BiometricCapability capability) {
    switch (capability) {
      case BiometricCapability.faceId:
        return 'Use Face ID to authenticate';
      case BiometricCapability.touchId:
        return 'Use Touch ID to authenticate';
      case BiometricCapability.fingerprint:
        return 'Use fingerprint to authenticate';
      default:
        return 'Please authenticate to continue';
    }
  }

  /// Saves the refresh token securely.
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  /// Retrieves the stored refresh token.
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  /// Clears the stored refresh token.
  Future<void> clearRefreshToken() async {
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  /// Enables or disables biometric authentication in the app settings.
  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorage.write(
      key: _biometricEnabledKey,
      value: enabled ? 'true' : 'false',
    );
    if (!enabled) await clearRefreshToken();
  }

  /// Attempts to login using biometrics and returns the refresh token if successful.
  Future<String?> loginWithBiometrics() async {
    if (!await canLoginWithBiometrics()) return null;
    final authenticated = await authenticate();
    if (!authenticated) return null;
    return await getRefreshToken();
  }

  /// Logs out the session.
  ///
  /// If biometric is disabled then also clear refresh token.
  Future<void> logoutSession() async {
    final enabled = await isBiometricEnabled();
    if (!enabled) {
      await clearRefreshToken();
    }
  }

  /// Disables biometric authentication in the app settings.
  Future<void> disableBiometric() async {
    await setBiometricEnabled(false);
  }
}
