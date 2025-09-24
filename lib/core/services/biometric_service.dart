import 'package:banking_app/core/utils/pref_keys.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

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

  Future<bool> authenticate() async {
    try {
      final isAvailable = await _auth.canCheckBiometrics;
      if (!isAvailable) return false;

      final didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to confirm transfer',
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
