import 'package:flutter/material.dart';
import 'package:laza/core/extensions/context_extensions.dart';

class LSSocialButton extends StatelessWidget {
  final String text;
  final Color color;
  final Widget? icon;
  final double width;
  final double height;
  final VoidCallback? onPressed;

  const LSSocialButton({
    super.key,
    required this.text,
    required this.color,
    required this.icon,
    this.onPressed,
    this.width = double.infinity,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: icon!,
        label: Text(
          text,
          style: context.textTheme.headlineLarge!
              .copyWith(color: context.colorScheme.onPrimary),
        ),
      ),
    );
  }
}
