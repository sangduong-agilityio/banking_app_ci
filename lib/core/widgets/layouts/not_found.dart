import 'package:banking_app/core/resources/assets_generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotFoundScreen extends StatelessWidget {
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
