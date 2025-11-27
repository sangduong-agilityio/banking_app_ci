import 'package:banking_app/app/router/app_router.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/data/services/biometric_service.dart';
import 'package:banking_app/core/security/biometric_capability.dart';
import 'package:banking_app/core/common/utils/pref_keys.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/dialog.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/auth/data/repositories/auth_repository.dart';
import 'package:banking_app/features/setting/data/models/user_model.dart';
import 'package:banking_app/features/setting/presentation/blocs/setting_cubit.dart';
import 'package:banking_app/features/setting/presentation/blocs/setting_state.dart';
import 'package:banking_app/features/setting/presentation/widgets/setting_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingCubit(
        repo: locator<AuthRepository>(),
        biometricService: locator<BiometricService>(),
      )..fetchProfile(),
      child: BAScaffold(
        appBar: BAAppBar(
          title: S.current.settingTitle,
          titleColor: context.colorScheme.onPrimary,
          alignment: BAAppBarAlignment.left,
          iconColor: context.colorScheme.onPrimary,
          backgroundColor: context.colorScheme.secondary,
        ),
        body: Container(
          color: context.colorScheme.secondary,
          child: const SettingContent(),
        ),
      ),
    );
  }
}

class SettingContent extends StatelessWidget {
  const SettingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      SettingCubit,
      SettingState,
      (SettingStatus, UserModel?, bool, BiometricCapability)
    >(
      selector: (state) => (
        state.status,
        state.user,
        state.isBiometricEnabled,
        state.biometricCapability,
      ),
      builder: (context, data) {
        final (status, user, isBiometricEnabled, biometricCapability) = data;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 50),
              decoration: BoxDecoration(
                color: context.colorScheme.onPrimary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 70),
                    Text(
                      user?.username ?? '',
                      style: context.titleMedium?.copyWith(
                        color: context.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SettingSelection(
                      title: S.current.settingPasswordTitle,
                      textColor: context.colorScheme.inverseSurface,
                      onTap: () {
                        BASnackBar.showNotSupported(
                          context,
                          S.current.pageNotSupportedYet,
                        );
                      },
                    ),
                    SettingSelection(
                      title: biometricCapability.settingsLabel,
                      isEnabled:
                          isBiometricEnabled && biometricCapability.isAvailable,
                      onToggle: biometricCapability.isAvailable
                          ? (value) => context
                                .read<SettingCubit>()
                                .toggleBiometric(value)
                          : null,
                    ),
                    SettingSelection(
                      title: S.current.settingLanguaguesTitle,
                      textColor: context.colorScheme.inverseSurface,
                      onTap: () {
                        BASnackBar.showNotSupported(
                          context,
                          S.current.pageNotSupportedYet,
                        );
                      },
                    ),
                    SettingSelection(
                      title: S.current.settingAppInformationTitle,
                      textColor: context.colorScheme.inverseSurface,
                      onTap: () {
                        BASnackBar.showNotSupported(
                          context,
                          S.current.pageNotSupportedYet,
                        );
                      },
                    ),
                    SettingSelection(
                      title: S.current.platformChannelTitle,
                      textColor: context.colorScheme.inverseSurface,
                      onTap: () {
                        context.pushNamed(BAPaths.platformChannelDemo.name);
                      },
                    ),
                    SettingSelection(
                      title: S.current.settingCustomerCareTitle,
                      subtitle: S.current.settingCustomerCareSubtitle,
                      textColor: context.colorScheme.inverseSurface,
                      onTap: () {
                        BASnackBar.showNotSupported(
                          context,
                          S.current.pageNotSupportedYet,
                        );
                      },
                    ),
                    SettingSelection(
                      title: S.current.settingLogoutTitle,
                      onTap: () => _showLogoutDialog(context),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: BAProfileImage(url: user?.profileImage, size: 100),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (ctx) => BADialog(
        title: S.current.settingLogoutTitle,
        content: S.current.settingLogoutContent,
        confirmButton: S.current.settingLogoutLogoutButton,
        confirmCancel: S.current.settingCancelButton,
        onAccept: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove(PrefKeys.sessionToken);
          if (context.mounted) {
            context.go(BAPaths.signIn.path);
          }
        },
        onCancel: () => Navigator.of(ctx).pop(),
      ),
    );
  }
}
