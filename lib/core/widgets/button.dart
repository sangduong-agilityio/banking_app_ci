import 'package:banking_app/app/themes/app_colors.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/widgets/text.dart';
import 'package:flutter/material.dart';

class BAElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final double? width;
  final double? height;

  const BAElevatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isDisabled = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 42),
      width: width ?? double.infinity,
      height: height ?? 44,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isDisabled ? null : BAAppColors.primaryGradient,
          color: isDisabled ? context.colorScheme.outlineVariant : null,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: BATitleMediumText(
            text: text,
            color: context.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
