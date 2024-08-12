import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/gen_assets/assets.gen.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        Assets.icons.icEmptyWidget.path,
        height: 200.h,
        width: 200.w,
      ),
    );
  }
}
