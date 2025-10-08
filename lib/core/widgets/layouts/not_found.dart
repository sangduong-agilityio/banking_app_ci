import 'package:banking_app/core/resources/assets_generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// A screen that is displayed when a route is not found.
///
/// This screen displays an image to indicate that the page is empty or not found.
class NotFoundScreen extends StatelessWidget {
  /// Creates a [NotFoundScreen] widget.
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        Assets.images.imgEmpty.path,
        width: 300,
        height: 300,
        fit: BoxFit.cover,
      ),
    );
  }
}
