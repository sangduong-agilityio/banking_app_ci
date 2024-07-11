import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/presentations/layout/scaffold.dart';
import 'package:laza/presentations/pages/brand_detail/widgets/grid_view_brand.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/icons.dart';

class BrandViewAll extends StatelessWidget {
  const BrandViewAll({super.key});

  @override
  Widget build(BuildContext context) {
    return LazaShopScaffold(
      paddingScaffold: 20,
      body: Column(
        children: [
          const SizedBox(height: 45),
          LSAppBar(
            onTappedBackButton: () => context.pop(),
            icon: LSIcons.icArrowLeft,
          ),
          const SizedBox(height: 15),
          Text(
            S.current.featuresBrands,
            style: context.textTheme.displayLarge,
          ),
          const SizedBox(height: 15),
          Text(
            S.current.chooseBrandYourSelf,
            style: context.textTheme.headlineSmall!
                .copyWith(color: context.colorScheme.tertiaryContainer),
          ),
          const SizedBox(height: 45),
          const GridViewBrand()
        ],
      ),
    );
  }
}
