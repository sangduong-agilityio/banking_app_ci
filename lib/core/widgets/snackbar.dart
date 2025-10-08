import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

/// A utility class for displaying snackbars with different styles.
class BASnackBar {
  BASnackBar._();

  /// Builds and shows an error snackbar.
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

  /// Builds and shows a snackbar for unsupported features.
  static void showNotSupported(
    BuildContext context,
    String message, {
    VoidCallback? onRetry,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackbar(
        context,
        message,
        context.colorScheme.inverseSurface,
        onRetry,
      ),
    );
  }

  /// Builds and shows a success snackbar.
  static buildSuccessSnackbar(
    BuildContext context,
    String message, {
    VoidCallback? onRetry,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackbar(
        context,
        message,
        context.colorScheme.surfaceTint,
        onRetry ?? () {},
      ),
    );
  }

  /// Builds a snackbar with the given parameters.
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
