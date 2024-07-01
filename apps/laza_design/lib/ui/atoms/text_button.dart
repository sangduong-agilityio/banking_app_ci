import 'package:flutter/material.dart';
import 'package:laza_design/core/extenssions/context_extenssions.dart';

class OlTextButton extends StatelessWidget {
  const OlTextButton({
    super.key,
    required this.text,
    this.onTap,
    this.textStyle,
    this.color,
  });
  final String text;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: textStyle ??
            context.textTheme.headlineSmall?.copyWith(
              color: color ?? context.colorScheme.primary,
              letterSpacing: 0.14,
            ),
      ),
    );
  }
}
