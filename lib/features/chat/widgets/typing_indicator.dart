import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({Key? key}) : super(key: key);

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _dotOffsets = [0.0, 10.0, 20.0];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final double offset = _dotOffsets[index];
              final double t = ((_controller.value * 1200) - offset) / 600;
              final double scale = -4 * pow(t - 0.5, 2) + 1;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                height: 8.0,
                width: 8.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                transform: Matrix4.identity()..scale(1.0 + scale * 0.5),
              );
            },
          );
        }),
      ),
    );
  }

  double pow(double x, double y) => x * x;
}