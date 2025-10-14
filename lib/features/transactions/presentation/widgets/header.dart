import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

/// A widget that displays a section header with a title.
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: context.bodyMedium?.copyWith(
          color: context.colorScheme.inverseSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
