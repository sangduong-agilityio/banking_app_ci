import 'package:banking_app/app/router/app_router.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/services/biometric_service.dart';
import 'package:banking_app/core/utils/pref_keys.dart';
import 'package:banking_app/core/widgets/dialog.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/auth/repositories/auth_repository.dart';
import 'package:banking_app/features/setting/states/setting_cubit.dart';
import 'package:banking_app/features/setting/states/setting_state.dart';
import 'package:banking_app/features/setting/widgets/setting_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
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
      child: LoaderOverlay(
        child: BAScaffold(
          appBar: BAAppBar(
            title: S.current.settingTitle,
            alignment: BAAppBarAlignment.left,
            titleColor: context.colorScheme.scrim,
            iconColor: context.colorScheme.scrim,
          ),
          body: BlocConsumer<SettingCubit, SettingState>(
            listener: (context, state) {
              state.status.maybeWhen(
                loading: () => context.loaderOverlay.show(),
                success: () => context.loaderOverlay.hide(),
                failure: () {
                  context.loaderOverlay.hide();
                  BASnackBar.buildErrorSnackbar(
                    context,
                    state.errorMessage ?? '',
                  );
                },
                orElse: () => context.loaderOverlay.hide(),
              );
            },
            builder: (context, state) {
              final user = state.user;
              return Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user?.profileImage ?? ''),
                  ),
                  const SizedBox(height: 15),
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
                    onTap: () {},
                  ),
                  SettingSelection(
                    title: S.current.settingTouchIdLabel,
                    isEnabled: state.isBiometricEnabled,
                    onToggle: (value) {
                      context.read<SettingCubit>().toggleBiometric(value);
                    },
                    padding: const EdgeInsets.symmetric(vertical: 5),
                  ),
                  SettingSelection(
                    title: S.current.settingLanguaguesTitle,
                    onTap: () {},
                  ),
                  SettingSelection(
                    title: S.current.settingAppInformationTitle,
                    onTap: () {},
                  ),
                  SettingSelection(
                    title: S.current.settingCustomerCareTitle,
                    subtitle: '19008989',
                    onTap: () {},
                  ),
                  SettingSelection(
                    title: S.current.settingLogoutTitle,
                    onTap: () => _showLogoutDialog(context),
                  ),
                ],
              );
            },
          ),
        ),
      ),
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
