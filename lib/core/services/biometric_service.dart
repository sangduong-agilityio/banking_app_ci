import 'package:banking_app/core/utils/pref_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const _refreshTokenKey = PrefKeys.biometricRefreshToken;
  static const _biometricEnabledKey = PrefKeys.biometricEnabled;

  /// Checks if the device supports biometric authentication
  Future<bool> canCheckBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  /// Authenticates the user using biometrics
  Future<bool> authenticate({bool fallbackPasscode = true}) async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
    } catch (_) {
      return false;
    }
  }

  /// Saves the refresh token securely
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  /// Retrieves the saved refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  /// Deletes the saved refresh token
  Future<void> clearRefreshToken() async {
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  /// Sets the biometric toggle (enabled/disabled)
  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorage.write(
      key: _biometricEnabledKey,
      value: enabled ? 'true' : 'false',
    );

    // If disabling biometrics, also clear the refresh token
    if (!enabled) await clearRefreshToken();
  }

  /// Checks if biometric login is enabled
  Future<bool> isBiometricEnabled() async {
    final value = await _secureStorage.read(key: _biometricEnabledKey);
    return value == 'true';
  }

  /// Checks if the user can login using biometrics
  /// Returns true only if device supports biometrics, biometric toggle is enabled, and refresh token exists
  Future<bool> canLoginWithBiometrics() async {
    final canCheck = await canCheckBiometrics();
    final enabled = await isBiometricEnabled();
    final token = await getRefreshToken();
    return canCheck && enabled && token != null;
  }

  /// Performs login using biometrics
  /// Returns the refresh token if successful, null otherwise
  Future<String?> loginWithBiometrics() async {
    if (!await canLoginWithBiometrics()) return null;
    final authenticated = await authenticate();
    if (!authenticated) return null;
    return await getRefreshToken();
  }

  /// Logs out the current session
  /// Does not remove the refresh token or biometric toggle
  Future<void> logoutSession() async {}

  /// Disables Touch ID / biometric login
  Future<void> disableBiometric() async {
    await setBiometricEnabled(false);
  }
}
