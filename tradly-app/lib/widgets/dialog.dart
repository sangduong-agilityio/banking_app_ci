import 'package:flutter/material.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/widgets/text.dart';

class TADialog extends StatelessWidget {
  const TADialog({
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
      title: TAHeadlineLargeText(
        text: title ?? '',
        fontWeight: FontWeight.w700,
        color: context.colorScheme.primary,
      ),
      content: TAHeadlineSmallText(
        text: content ?? '',
        color: context.colorScheme.outline,
        fontWeight: FontWeight.w400,
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: TAHeadlineSmallText(
            text: confirmCancel ?? '',
            fontWeight: FontWeight.w700,
            color: context.colorScheme.onSecondary,
          ),
        ),
        TextButton(
          onPressed: onAccept,
          child: TAHeadlineSmallText(
            text: confirmButton ?? '',
            fontWeight: FontWeight.w700,
            color: context.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
