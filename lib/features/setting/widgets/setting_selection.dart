import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingSelection extends StatelessWidget {
  const SettingSelection({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isEnabled,
    this.onToggle,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool? isEnabled;
  final ValueChanged<bool>? onToggle;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final hasSwitch = isEnabled != null && onToggle != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: GestureDetector(
        onTap: hasSwitch ? null : onTap,
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: context.colorScheme.onTertiary,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: context.titleMedium),
              if (hasSwitch)
                Switch(
                  value: isEnabled ?? false,
                  onChanged: onToggle,
                  activeColor: context.colorScheme.secondary,
                )
              else
                Row(
                  children: [
                    if (subtitle != null)
                      Text(subtitle!, style: context.bodySmall),
                    if (subtitle != null) const SizedBox(width: 8),
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
