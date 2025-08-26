import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/setting/models/setting_model.dart';
import 'package:banking_app/features/setting/views/password_change_screen.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key, this.users});
  final SettingModel? users;

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      appBar: BAAppBar(
        title: S.current.settingTitle,
        titleColor: context.colorScheme.scrim,
        alignment: BAAppBarAlignment.left,
        iconColor: context.colorScheme.scrim,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(users?.profileImage ?? ''),
            ),
          ),
          SizedBox(height: 15),
          Text(
            users?.fullName ?? '',
            style: context.titleMedium?.copyWith(
              color: context.colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SettingOption(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PasswordChangeScreen()),
              );
            },
            title: S.current.settingPasswordTitle,
          ),
          SettingOption(onTap: () {}, title: S.current.settingLanguaguesTitle),
          SettingOption(
            onTap: () {},
            title: S.current.settingAppInformationTitle,
          ),

          SettingOption(
            onTap: () {},
            title: S.current.settingCustomerCareTitle,
            subtitle: '19008989',
          ),
          SettingOption(onTap: () {}, title: S.current.settingLogoutTitle),
        ],
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
