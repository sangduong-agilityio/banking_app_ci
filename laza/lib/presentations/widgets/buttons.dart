import 'package:flutter/material.dart';
import 'package:laza/core/extensions/context_extensions.dart';

class LSButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Widget? loading;
  final bool isDisabled;

  const LSButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 75,
    this.loading,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            textStyle: TextStyle(
              color: context.colorScheme.onPrimary,
            ),
          ),
          child: loading ??
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: EdgeInsets.only(left: 14),
                    ),
                  ),
                  Text(
                    text,
                    style: context.textTheme.headlineLarge!.copyWith(
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                ],
              )),
    );
  }
}
