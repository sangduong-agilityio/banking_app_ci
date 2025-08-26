import 'package:banking_app/app/router/app_router.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/dialog.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/not_found.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/auth/services/auth_repository.dart';
import 'package:banking_app/features/setting/bloc/setting_cubit.dart';
import 'package:banking_app/features/setting/bloc/setting_state.dart';
import 'package:banking_app/features/setting/views/password_change_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SettingCubit(repo: locator.get<AuthRepository>())..fetchProfile(),
      child: BAScaffold(
        appBar: BAAppBar(
          title: S.current.settingTitle,
          titleColor: context.colorScheme.scrim,
          alignment: BAAppBarAlignment.left,
          iconColor: context.colorScheme.scrim,
        ),
        body: BlocBuilder<SettingCubit, SettingState>(
          buildWhen: (previous, current) =>
              previous.status != current.status ||
              previous.user != current.user,
          builder: (context, state) {
            if (state.status is SettingStatusLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status is SettingStatusSuccess) {
              final user = state.user;
              return Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                        user?.profileImage ?? 'assets/images/img_empty.png',
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    user?.fullName ?? '',
                    style: context.titleMedium?.copyWith(
                      color: context.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SettingOption(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PasswordChangeScreen(),
                        ),
                      );
                    },
                    title: S.current.settingPasswordTitle,
                  ),
                  SettingOption(
                    onTap: () {},
                    title: S.current.settingLanguaguesTitle,
                  ),
                  SettingOption(
                    onTap: () {},
                    title: S.current.settingAppInformationTitle,
                  ),

                  SettingOption(
                    onTap: () {},
                    title: S.current.settingCustomerCareTitle,
                    subtitle: '19008989',
                  ),
                  SettingOption(
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                    title: S.current.settingLogoutTitle,
                  ),
                ],
              );
            } else if (state.status is SettingStatusFailure) {
              return NotFoundScreen();
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class SettingOption extends StatelessWidget {
  const SettingOption({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
  });
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: context.titleMedium),
              Row(
                children: [
                  if (subtitle != null)
                    Text(subtitle ?? '', style: context.bodySmall),
                  SizedBox(width: 8),
                  if (subtitle == null)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future _showLogoutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return BADialog(
        title: S.current.settingLogoutTitle,
        content: S.current.settingLogoutContent,
        confirmButton: S.current.settingLogoutLogoutButton,
        confirmCancel: S.current.settingCancelButton,
        onAccept: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('session_token');
          if (context.mounted) {
            context.go(BAPaths.signIn.path);
          }
        },
        onCancel: () {
          Navigator.of(ctx).pop();
        },
      );
    },
  );
}
