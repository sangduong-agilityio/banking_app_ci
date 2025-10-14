import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:flutter/material.dart';

/// A widget that displays a central image with several animated floating dots.
///
/// The dots are configured using a list of [DotConfig] objects.
class AnimatedDot extends StatelessWidget {
  /// Creates an [AnimatedDot] object.
  const AnimatedDot({super.key});

  @override
  Widget build(BuildContext context) {
    final dots = _getDots(context);

    return Center(
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [
            // The central image.
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: context.colorScheme.onSurfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Center(child: BAAssets.lockDriver()),
              ),
            ),
            // The animated floating dots.
            ...dots.map(
              (config) => AnimatedFloatingDot(
                key: ValueKey(config.delay),
                color: config.color,
                size: config.size,
                left: config.left,
                right: config.right,
                top: config.top,
                bottom: config.bottom,
                delay: config.delay,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DotConfig> _getDots(BuildContext context) {
    return [
      DotConfig(
        color: context.colorScheme.secondary,
        size: 10,
        left: 110,
        top: 10,
        delay: 0,
      ),
      DotConfig(
        color: context.colorScheme.surfaceTint,
        size: 10,
        left: 60,
        top: 60,
        delay: 500,
      ),
      DotConfig(
        color: context.colorScheme.tertiary,
        size: 10,
        right: 80,
        top: 130,
        delay: 2000,
      ),
      DotConfig(
        color: context.colorScheme.error,
        size: 18,
        right: 70,
        top: 40,
        delay: 1500,
      ),
      DotConfig(
        color: context.colorScheme.inversePrimary,
        size: 20,
        left: 90,
        top: 140,
        delay: 1000,
      ),
    ];
  }
}

/// A configuration class for a single animated floating dot.
class DotConfig {
  /// The color of the dot.
  final Color color;

  /// The size of the dot.
  final double size;

  /// The position of the dot from the left.
  final double? left;

  /// The position of the dot from the right.
  final double? right;

  /// The position of the dot from the top.
  final double? top;

  /// The position of the dot from the bottom.
  final double? bottom;

  /// The delay in milliseconds before the animation starts.
  final int delay;

  /// Creates a [DotConfig] object.
  DotConfig({
    required this.color,
    required this.size,
    this.left,
    this.right,
    this.top,
    this.bottom,
    required this.delay,
  });
}

/// A widget that displays a single animated floating dot.
class AnimatedFloatingDot extends StatefulWidget {
  /// The color of the dot.
  final Color color;

  /// The size of the dot.
  final double size;

  /// The position of the dot from the left.
  final double? left;

  /// The position of the dot from the right.
  final double? right;

  /// The position of the dot from the top.
  final double? top;

  /// The position of the dot from the bottom.
  final double? bottom;

  /// The delay in milliseconds before the animation starts.
  final int delay;

  /// Creates an [AnimatedFloatingDot] object.
  const AnimatedFloatingDot({
    super.key,
    required this.color,
    required this.size,
    this.left,
    this.right,
    this.top,
    this.bottom,
    required this.delay,
  });

  @override
  AnimatedFloatingDotState createState() => AnimatedFloatingDotState();
}

class AnimatedFloatingDotState extends State<AnimatedFloatingDot>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start the animation after a delay.
    // This is used to stagger the start of the animations for different dots.
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      right: widget.right,
      top: widget.top,
      bottom: widget.bottom,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _animation.value * 10),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }
}
