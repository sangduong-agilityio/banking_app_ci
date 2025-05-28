import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/core/routes/app_router.dart';
import 'package:tradly_app/data/repositories/product_repo.dart';
import 'package:tradly_app/presentations/layouts/app_bar.dart';
import 'package:tradly_app/presentations/layouts/scaffold.dart';
import 'package:tradly_app/presentations/pages/product_detail/states/product_detail_bloc.dart';
import 'package:tradly_app/presentations/pages/product_detail/states/product_detail_event.dart';
import 'package:tradly_app/presentations/pages/product_detail/states/product_detail_state.dart';
import 'package:tradly_app/presentations/widgets/card.dart';
import 'package:tradly_app/presentations/widgets/not_found.dart';
import 'package:tradly_app/presentations/widgets/shimmer.dart';

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
    final crossAxisCount = isPortrait ? 8 : 8;

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
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (crossAxisCount * 60),
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
