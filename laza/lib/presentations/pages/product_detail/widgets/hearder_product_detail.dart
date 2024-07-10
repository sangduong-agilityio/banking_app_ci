import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/gen_assets/assets.gen.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/presentations/widgets/images.dart';

class HeaderProductDetail extends StatelessWidget {
  const HeaderProductDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        LSImage(
          imageUrl: Assets.images.dataImage.path,
          width: double.infinity,
          height: 375,
          fit: BoxFit.cover,
          borderRadius: 0,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 65,
              right: 20,
              left: 20,
            ),
            child: LSAppBar(
              onTappedBackButton: () => context.pop(),
              icon: LSIcons.icArrowLeft,
              rightButtonIcon: LSIcons.icBag,
              onTappedRightButton: () {},
            ),
          ),
        ),
      ],
    );
  }
}
