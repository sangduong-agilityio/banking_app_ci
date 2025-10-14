import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

/// A custom elevated button widget with a specific design.
///
/// This button can be disabled and its dimensions can be customized.
class BAElevatedButton extends StatefulWidget {
  /// Creates a [BAElevatedButton] widget.
  const BAElevatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isDisabled = false,
    this.width,
    this.height,
    this.padding,
  });

  /// The text to display on the button.
  final String text;

  /// The callback that is called when the button is tapped.
  final VoidCallback? onPressed;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The width of the button.
  final double? width;

  /// The height of the button.
  final double? height;

  /// The padding of the button.
  final EdgeInsetsGeometry? padding;

  @override
  State<BAElevatedButton> createState() => _BAElevatedButtonState();
}

/// The state for a [BAElevatedButton] widget.
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
