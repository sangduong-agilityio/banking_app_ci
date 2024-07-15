import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';

class LSLoadingIndicator extends StatelessWidget {
  const LSLoadingIndicator({
    super.key,
    this.radius,
    this.color,
  });

  /// The radius of the circular loading indicator.
  final double? radius;

  /// The color of the circular loading indicator.
  final Color? color;

  static Future<LSLoadingIndicator?> show(
    BuildContext ctx, {
    double? radius,
    Color? color,
  }) {
    return showDialog<LSLoadingIndicator>(
      context: ctx,
      builder: (_) => PopScope(
        canPop: false,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: LSLoadingIndicator(
            radius: radius,
            color: color,
          ),
        ),
      ),
    );
  }

  /// Hides the loading indicator dialog.
  static void hide(BuildContext ctx) {
    ctx.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: CircularProgressIndicator(
          strokeAlign: radius ?? 5,
          color: color ?? context.colorScheme.primary,
        ),
      ),
    );
  }
}
