import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class BADialog extends StatelessWidget {
  const BADialog({
    required this.title,
    required this.content,
    this.confirmButton,
    this.confirmCancel,
    this.onAccept,
    this.onCancel,
    super.key,
  });

  final VoidCallback? onAccept;
  final VoidCallback? onCancel;
  final String? title;
  final String? content;
  final String? confirmButton;
  final String? confirmCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title ?? '',
        style: context.headlineMedium,
        textAlign: TextAlign.center,
      ),
      content: Text(
        content ?? '',
        style: context.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: onCancel,
              child: Text(confirmCancel ?? '', style: context.bodyMedium),
            ),
            TextButton(
              onPressed: onAccept,
              child: Text(
                confirmButton ?? '',
                style: context.bodyMedium?.copyWith(
                  color: context.colorScheme.primaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
