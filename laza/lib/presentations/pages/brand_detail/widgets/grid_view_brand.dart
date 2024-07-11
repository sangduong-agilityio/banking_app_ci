import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/gen_assets/assets.gen.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/presentations/widgets/brand.dart';

class GridViewBrand extends StatelessWidget {
  const GridViewBrand({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 15,
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        childAspectRatio: 3 / 1,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            context.pushNamed(
              AppRoutesName.brandDetailPage.name,
              extra: e,
            );
          },
          child: LSBrand(
            brandName: 'Nike',
            brandLogo: Assets.images.dataImage.path,
          ),
        );
      },
    );
  }
}
