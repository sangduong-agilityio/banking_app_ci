import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/configs/app_router.dart';
import 'package:tradly_app/features/product_detail/repositories/product_repo.dart';
import 'package:tradly_app/utils/responsive.dart';
import 'package:tradly_app/widgets/layouts/app_bar.dart';
import 'package:tradly_app/widgets/layouts/scaffold.dart';
import 'package:tradly_app/features/product_detail/states/product_detail_bloc.dart';
import 'package:tradly_app/features/product_detail/states/product_detail_event.dart';
import 'package:tradly_app/features/product_detail/states/product_detail_state.dart';
import 'package:tradly_app/widgets/card.dart';
import 'package:tradly_app/widgets/not_found.dart';
import 'package:tradly_app/widgets/shimmer.dart';

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    required this.title,
    required this.categoryId,
    this.productId,
  });

  final String title;
  final int categoryId;
  final int? productId;
  final bool isPortrait = true;

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = TAResponsive.orientationSizeOf(
      context,
      portrait: 2,
      landscape: 4,
    );

    return BlocProvider(
      create: (context) => ProductDetailBloc(
        repo: context.read<ProductRepository>(),
      )..add(ProductDetailInitializeEvt(categoryId: categoryId)),
      child: TAScaffold(
        appBar: TAAppBar.productList(
          backgroundColor: context.colorScheme.primary,
          title: title,
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
        body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
            buildWhen: (previous, current) =>
                previous.status != current.status ||
                previous.products != current.products,
            builder: (context, state) {
              if (state.status is ProductDetailStatusLoading) {
                return ShimmerProductGrid();
              } else if (state.status is ProductDetailStatusSuccess) {
                final products = state.products ?? [];
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount.toInt(),
                      childAspectRatio: TAResponsive.orientationSizeOf(
                        context,
                        portrait: TAResponsive.isTablet(context) ? 1.4 : 0.8,
                        landscape: 1.2,
                      ),
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Semantics(
                        hint: S.current.productDetailDoubleTapHint,
                        child: TACardProduct(
                          onTapProduct: () {
                            TARouter.navigateTo(
                              context,
                              TAPaths.productDetail.name,
                              extra: state.products?[index].id,
                            );
                          },
                          product: products[index],
                        ),
                      );
                    },
                  ),
                );
              } else if (state.status is ProductDetailStatusFailure) {
                return NotFoundScreen();
              }
              return const SizedBox.shrink();
            }),
      ),
    );
  }
}
