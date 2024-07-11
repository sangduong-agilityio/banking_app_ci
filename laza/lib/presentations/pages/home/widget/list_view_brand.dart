import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/gen_assets/assets.gen.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/presentations/widgets/brand.dart';

class ListViewBrand extends StatelessWidget {
  const ListViewBrand({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRoutesName.brandViewAll.name,
          extra: e,
        );
      },
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: LSBrand(
                brandName: 'Nike',
                brandLogo: Assets.images.dataImage.path,
              ),
            );
          },
        ),
      ),
    );
  }
}
