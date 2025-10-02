import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/features/auth/repositories/auth_repository.dart';
import 'package:banking_app/features/auth/states/auth_bloc.dart';
import 'package:banking_app/features/auth/states/auth_event.dart';
import 'package:banking_app/features/setting/models/user_model.dart';
import 'package:banking_app/features/setting/states/setting_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:banking_app/core/services/biometric_service.dart';
import 'package:banking_app/core/services/biometric_capability.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit({required this.repo, required this.biometricService})
    : super(const SettingState());

  final AuthRepository repo;
  final BiometricService biometricService;
  final supabase = Supabase.instance.client;

  /// Fetch user profile + biometric info
  Future<void> fetchProfile() async {
    emit(state.copyWith(status: const SettingStatus.loading()));
    try {
      final currentUser = supabase.auth.currentUser;

      final response = await supabase
          .from('users')
          .select('username, email, profileImage')
          .eq('id', currentUser?.id ?? '')
          .maybeSingle();

      final user = UserModel(
        username: response?['username'] ?? '',
        email: response?['email'] ?? currentUser?.email ?? '',
        phoneNumber: currentUser?.phone ?? '',
        profileImage: response?['profileImage'] ?? '',
      );

      final isEnabled = await biometricService.isBiometricEnabled();
      final hasSaved = await biometricService.getRefreshToken() != null;
      final isAvailable = await biometricService.canCheckBiometrics();
      final capability = await biometricService.getBiometricCapability();

      emit(
        state.copyWith(
          user: user,
          status: const SettingStatus.success(),
          isBiometricEnabled: isEnabled,
          hasSavedBiometricCredentials: hasSaved,
          isBiometricAvailable: isAvailable,
          biometricCapability: capability,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const SettingStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Toggle biometric authentication
  Future<void> toggleBiometric(bool enable) async {
    if (enable) {
      final capability = await biometricService.getBiometricCapability();
      if (!capability.isAvailable) {
        emit(
          state.copyWith(
            status: const SettingStatus.failure(),
            errorMessage:
                'Biometric authentication is not available on this device',
          ),
        );
        return;
      }

      final authenticated = await biometricService.authenticate(
        customReason: 'Authenticate to enable ${capability.displayName}',
      );
      if (!authenticated) return;

      final refreshToken = supabase.auth.currentSession?.refreshToken;
      if (refreshToken == null || refreshToken.isEmpty) return;

      await biometricService.saveRefreshToken(refreshToken);
      await biometricService.setBiometricEnabled(true);

      emit(
        state.copyWith(
          isBiometricEnabled: true,
          hasSavedBiometricCredentials: true,
          status: const SettingStatus.success(),
        ),
      );

      // Show success message
      emit(
        state.copyWith(
          status: const SettingStatus.success(),
          errorMessage: capability.enabledMessage,
        ),
      );
    } else {
      await biometricService.disableBiometric();
      final capability = state.biometricCapability;

      emit(
        state.copyWith(
          isBiometricEnabled: false,
          hasSavedBiometricCredentials: false,
          status: const SettingStatus.success(),
          errorMessage: capability.disabledMessage,
        ),
      );
    }

    locator<AuthBloc>().add(const CheckBiometricAvailabilityEvt());
  }

  /// Logout app
  Future<void> logout() async {
    await repo.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_token');

    if (!await biometricService.isBiometricEnabled()) {
      await biometricService.clearRefreshToken();
    }

    locator<AuthBloc>().add(const CheckBiometricAvailabilityEvt());
  }
}
