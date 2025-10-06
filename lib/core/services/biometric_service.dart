import 'package:banking_app/core/utils/pref_keys.dart';
import 'package:banking_app/core/services/biometric_capability.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:io';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const _refreshTokenKey = PrefKeys.biometricRefreshToken;
  static const _biometricEnabledKey = PrefKeys.biometricEnabled;

  Future<bool> canCheckBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (_) {
      return <BiometricType>[];
    }
  }

  /// Get device-specific biometric capabilities
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

  /// Get user-friendly biometric type name
  Future<String> getBiometricTypeName() async {
    final capability = await getBiometricCapability();
    return capability.displayName;
  }

  /// Check if specific biometric type is available
  Future<bool> hasFaceId() async {
    final capability = await getBiometricCapability();
    return capability == BiometricCapability.faceId;
  }

  Future<bool> hasTouchId() async {
    final capability = await getBiometricCapability();
    return capability == BiometricCapability.touchId ||
        capability == BiometricCapability.fingerprint;
  }

  Future<bool> isBiometricEnabled() async {
    final value = await _secureStorage.read(key: _biometricEnabledKey);
    return value == 'true';
  }

  Future<bool> canLoginWithBiometrics() async {
    final canCheck = await canCheckBiometrics();
    final enabled = await isBiometricEnabled();
    final token = await getRefreshToken();
    return canCheck && enabled && token != null;
  }

  Future<bool> canUseBiometrics() async {
    final available = await getAvailableBiometrics();
    final enabled = await isBiometricEnabled();
    return available.isNotEmpty && enabled;
  }

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

  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  Future<void> clearRefreshToken() async {
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorage.write(
      key: _biometricEnabledKey,
      value: enabled ? 'true' : 'false',
    );
    if (!enabled) await clearRefreshToken();
  }

  Future<String?> loginWithBiometrics() async {
    if (!await canLoginWithBiometrics()) return null;
    final authenticated = await authenticate();
    if (!authenticated) return null;
    return await getRefreshToken();
  }

  /// Logs out session.
  /// If biometric is disabled then also clear refresh token.
  Future<void> logoutSession() async {
    final enabled = await isBiometricEnabled();
    if (!enabled) {
      await clearRefreshToken();
    }
  }

  Future<void> disableBiometric() async {
    await setBiometricEnabled(false);
  }
}
