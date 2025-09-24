import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class BAElevatedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const BAElevatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isDisabled = false,
    this.width,
    this.height,
    this.padding,
  });

  @override
  State<BAElevatedButton> createState() => _BAElevatedButtonState();
}

class _BAElevatedButtonState extends State<BAElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 30),
      width: widget.width ?? double.infinity,
      height: widget.height ?? 44,
      child: ElevatedButton(
        onPressed: widget.isDisabled ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          elevation: 0,
          backgroundColor: widget.isDisabled
              ? context.colorScheme.outlineVariant
              : context.colorScheme.secondary,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          widget.text,
          style: context.bodyLarge?.copyWith(
            color: context.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
