import 'package:flutter/material.dart';
import 'package:laza/core/themes/colors.dart';

class LSStarRating extends StatelessWidget {
  const LSStarRating({
    super.key,
    required this.rating,
    this.size = 13,
    this.spacing = 0,
    this.activeColor = LSColors.orange,
    this.inactiveColor = LSColors.grey300,
    this.showInactivate = true,
  });

  final double rating;
  final double size;
  final double spacing;
  final Color activeColor;
  final Color inactiveColor;
  final bool showInactivate;

  @override
  Widget build(BuildContext context) {
    int activeRating = rating.floor();
    bool isHalf = (activeRating != rating);
    List<Widget> stars = [];

    for (int i = 0; i < activeRating; i++) {
      stars.add(Icon(
        Icons.star,
        color: activeColor,
        size: size,
      ));
      stars.add(SizedBox(width: spacing));
    }

    if (isHalf) {
      stars.add(Icon(
        Icons.star_half_outlined,
        color: activeColor,
        size: size,
      ));
      stars.add(SizedBox(width: spacing));
    }

    if (showInactivate) {
      for (int i = activeRating + (isHalf ? 1 : 0); i < 5; i++) {
        stars.add(Icon(
          Icons.star_outline,
          color: inactiveColor,
          size: size,
        ));
        stars.add(SizedBox(width: spacing));
      }
    }

    return Row(children: stars);
  }
}
