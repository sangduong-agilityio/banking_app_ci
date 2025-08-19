import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class BASnackBar {
  BASnackBar._();

  static buildErrorSnackbar(
    BuildContext context,
    String message, {
    VoidCallback? onRetry,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackbar(
        context,
        message,
        context.colorScheme.error,
        onRetry ?? () {},
      ),
    );
  }

  static buildSuccessSnackbar(
    BuildContext context,
    String message, {
    VoidCallback? onRetry,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackbar(
        context,
        message,
        context.colorScheme.outlineVariant,
        onRetry ?? () {},
      ),
    );
  }

  static SnackBar _buildSnackbar(
    BuildContext context,
    String message,
    Color colorBackground,
    VoidCallback? onRetry,
  ) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      action: onRetry != null
          ? SnackBarAction(label: '', onPressed: onRetry)
          : null,
      backgroundColor: colorBackground,
      content: Text(
        message,
        style: context.textTheme.bodyLarge?.copyWith(
          color: context.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
