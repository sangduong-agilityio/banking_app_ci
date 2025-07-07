import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/features/product_detail/states/product_detail_event.dart';
import 'package:tradly_app/features/wish_list/states/wish_list_cubit.dart';
import 'package:tradly_app/resources/assets_generated/assets.gen.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/features/product_detail/repositories/product_repo.dart';
import 'package:tradly_app/utils/locator.dart';
import 'package:tradly_app/widgets/layouts/app_bar.dart';
import 'package:tradly_app/widgets/layouts/scaffold.dart';
import 'package:tradly_app/features/product_detail/states/product_detail_bloc.dart';
import 'package:tradly_app/features/product_detail/states/product_detail_state.dart';
import 'package:tradly_app/features/product_detail/views/checkout.dart';
import 'package:tradly_app/widgets/button.dart';
import 'package:tradly_app/widgets/images.dart';
import 'package:tradly_app/widgets/text.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailBloc(
        repo: locator.get<ProductRepository>(),
      )..add(ProductDetailFetchEvt(productId: productId)),
      child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        buildWhen: (previous, current) =>
            previous.product != current.product ||
            previous.status != current.status,
        builder: (context, state) {
          final product = state.product;

          return TAScaffold(
            appBar: TAAppBar.productDetail(
              bottomType: TAAppBarBottomType.imageBackground,
              background: product?.imageUrl != null
                  ? Image.network(
                      product?.imageUrl ?? '',
                      width: double.infinity,
                      height: 240,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    )
                  : const Icon(Icons.error),
              actions: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colorScheme.onPrimary.withAlpha(50),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {},
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colorScheme.onPrimary.withAlpha(50),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: context
                              .watch<WishListCubit>()
                              .state
                              .wishlist
                              .any((item) => item.id == product?.id)
                          ? context.colorScheme.error
                          : null,
                    ),
                    onPressed: () {
                      if (product != null) {
                        final wishListCubit = context.read<WishListCubit>();
                        if (wishListCubit.state.wishlist
                            .any((item) => item.id == product.id)) {
                          wishListCubit.removeFromWishList(product);
                        } else {
                          wishListCubit.addToWishList(product);
                        }
                      }
                    },
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colorScheme.onPrimary.withAlpha(50),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ),
              ],
              onBackPressed: () => Navigator.pop(context),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          color: context.colorScheme.onPrimary,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TAHeadlineMediumText(
                                text: product?.title ?? '',
                                color: context.colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  TAHeadlineMediumText(
                                    text: '${product?.newPrice ?? 0}',
                                    color: context.colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  SizedBox(width: 8),
                                  TATitleLargeText(
                                    text: '${product?.price ?? 0}',
                                    decoration: TextDecoration.combine([
                                      TextDecoration.lineThrough,
                                    ]),
                                    color: context.colorScheme.onSurface,
                                  ),
                                  SizedBox(width: 8),
                                  TATitleLargeText(
                                    text: S.current.productDetailSaleOffTitle,
                                    color: context.colorScheme.onSurface,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          color: context.colorScheme.onPrimary,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  TAImageCircle(
                                    radius: 20,
                                    Assets.images.imgTradly.path,
                                    boxFit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 10),
                                  TATitleLargeText(
                                    text: product?.brand ?? '',
                                    color: context.colorScheme.onSurface,
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(80, 25),
                                    backgroundColor:
                                        context.colorScheme.primary,
                                  ),
                                  child: TATitleMediumText(
                                    text: S.current.homeFollowButton,
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          color: context.colorScheme.onPrimary,
                          child: Column(
                            children: [
                              SizedBox(height: 30),
                              TATitleLargeText(
                                text: product?.description ?? '',
                                color: context.colorScheme.outline,
                              ),
                              SizedBox(height: 20),
                              _buildDetailRow(
                                S.current.productDetailConditionTitle,
                                product?.condition ?? '',
                                context,
                              ),
                              SizedBox(height: 12),
                              _buildDetailRow(
                                S.current.productDetailPriceTypeTitle,
                                product?.priceType ?? '',
                                context,
                              ),
                              SizedBox(height: 12),
                              _buildDetailRow(
                                S.current.productDetailCategoryTitle,
                                product?.categoryType ?? '',
                                context,
                              ),
                              SizedBox(height: 12),
                              _buildDetailRow(
                                S.current.productDetailLocationTitle,
                                product?.location ?? '',
                                context,
                              ),
                              SizedBox(height: 24),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          color: context.colorScheme.onPrimary,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TAHeadlineMediumText(
                                text:
                                    S.current.productDetailDeliveryOptionsTitle,
                                color: context.colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                              SizedBox(height: 15),
                              _buildDetailRow(
                                S.current.productDetailDeliveryTitle,
                                S.current.productDetailDeliveryDescription,
                                context,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(20),
              color: context.colorScheme.onPrimary,
              child: TAElevatedButton(
                backgroundColor: context.colorScheme.primary,
                text: S.current.productDetailAddToCartButton,
                onPressed: () {
                  if (product != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(product: product),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: TATitleLargeText(
            text: label,
            color: context.colorScheme.outline,
          ),
        ),
        Expanded(
          flex: 3,
          child: TATitleLargeText(
            text: value,
            color: context.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
