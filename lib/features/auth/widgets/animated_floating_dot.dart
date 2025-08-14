import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:flutter/material.dart';

class AnimatedDot extends StatelessWidget {
  const AnimatedDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [
            AnimatedFloatingDot(
              color: context.colorScheme.secondary,
              size: 10,
              left: 110,
              top: 10,
              delay: 0,
            ),
            AnimatedFloatingDot(
              color: context.colorScheme.surfaceTint,
              size: 10,
              left: 40,
              top: 60,
              delay: 500,
            ),

            AnimatedFloatingDot(
              color: context.colorScheme.tertiary,
              size: 10,
              right: 60,
              top: 130,
              delay: 2000,
            ),
            AnimatedFloatingDot(
              color: context.colorScheme.error,
              size: 18,
              right: 50,
              top: 40,
              delay: 1500,
            ),
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
            AnimatedFloatingDot(
              color: context.colorScheme.inversePrimary,
              size: 20,
              left: 90,
              top: 140,
              delay: 1000,
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedFloatingDot extends StatefulWidget {
  final Color color;
  final double size;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final int delay;

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
  _AnimatedFloatingDotState createState() => _AnimatedFloatingDotState();
}

class _AnimatedFloatingDotState extends State<AnimatedFloatingDot>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

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
