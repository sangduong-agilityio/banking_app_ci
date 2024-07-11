import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/gen_assets/assets.gen.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/presentations/layout/scaffold.dart';
import 'widgets/sort_detail.dart';
import '../home/widget/grid_view_products.dart';

class BrandDetailPage extends StatelessWidget {
  const BrandDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LazaShopScaffold(
        paddingScaffold: 20,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              LSAppBar(
                onTappedBackButton: () => context.pop(),
                icon: LSIcons.icArrowLeft,
                rightButtonIcon: LSIcons.icBag,
                onTappedRightButton: () {},
                centerImage: Assets.images.dataImage.path,
              ),
              const SizedBox(height: 49),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.current.totalItems(256),
                        style: context.textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        S.current.availableInStock,
                        style: context.textTheme.headlineMedium!.copyWith(
                            color: context.colorScheme.tertiaryContainer),
                      ),
                    ],
                  ),
                  const LSSort()
                ],
              ),
              const SizedBox(height: 20),
              const GridViewProduct()
            ],
          ),
        ));
  }
}
