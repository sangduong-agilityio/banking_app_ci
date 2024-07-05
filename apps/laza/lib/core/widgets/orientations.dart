import 'package:flutter/material.dart';

class LSOrientation extends StatelessWidget {
  final Widget portraitWidget;
  final Widget landscapeWidget;

  const LSOrientation({
    super.key,
    required this.portraitWidget,
    required this.landscapeWidget,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (MediaQuery.of(context).orientation == Orientation.landscape) {
          return landscapeWidget;
        } else {
          return portraitWidget;
        }
      },
    );
  }
}
