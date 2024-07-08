import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/widgets/app_bar.dart';
import 'package:laza/core/widgets/icons.dart';
import 'package:laza/core/widgets/images.dart';

class HeaderProductDetail extends StatelessWidget {
  const HeaderProductDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const LSImage(
          imageUrl: 'https://picsum.photos/seed/picsum/200/300',
          width: double.infinity,
          height: 375,
          fit: BoxFit.cover,
          borderRadius: 0,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
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
