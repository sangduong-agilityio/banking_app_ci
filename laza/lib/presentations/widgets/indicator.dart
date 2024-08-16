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

  final double? radius;

  final Color? color;

  static Future<LSLoadingIndicator?> show(
    BuildContext context, {
    double? radius,
    Color? color,
  }) {
    return showDialog<LSLoadingIndicator>(
      context: context,
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
