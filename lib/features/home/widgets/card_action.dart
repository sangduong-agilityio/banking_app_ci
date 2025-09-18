import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class CardAction extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback? onTap;
  const CardAction({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Color(0xFFCBD5E0).withAlpha(150), blurRadius: 5),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.bodySmall?.copyWith(
                color: context.colorScheme.inverseSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
