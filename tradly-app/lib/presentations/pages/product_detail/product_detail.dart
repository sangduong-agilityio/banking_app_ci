import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/assets_generated/assets.gen.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/data/repositories/product_repo.dart';
import 'package:tradly_app/presentations/layouts/app_bar.dart';
import 'package:tradly_app/presentations/pages/product_detail/states/product_detail_bloc.dart';
import 'package:tradly_app/presentations/pages/product_detail/states/product_detail_event.dart';
import 'package:tradly_app/presentations/pages/product_detail/states/product_detail_state.dart';
import 'package:tradly_app/presentations/widgets/images.dart';
import 'package:tradly_app/presentations/widgets/text.dart';

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
        repo: context.read<ProductRepository>(),
      )..add(
          ProductDetailFetchEvt(
            productId: productId,
          ),
        ),
      child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
        final product = state.product;
        return Scaffold(
          backgroundColor: context.colorScheme.inversePrimary,
          appBar: TaAppBar.details(
            background: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    product?.imageUrl ?? '',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
                            TaHeadlineMediumText(
                              text: product?.title ?? '',
                              color: context.colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                TaHeadlineMediumText(
                                  text: product?.newPrice ?? '',
                                  color: context.colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                                SizedBox(width: 8),
                                TaTitleLargeText(
                                  text: product?.price ?? '',
                                  color: context.colorScheme.onSurface,
                                ),
                                SizedBox(width: 8),
                                TaTitleLargeText(
                                  text: '50% off',
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
                                TaTitleLargeText(
                                  text: 'Tradly Store',
                                  color: context.colorScheme.onSurface,
                                ),
                              ],
                            ),
                            ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(80, 25),
                                  backgroundColor: context.colorScheme.primary,
                                ),
                                child: TaTitleMediumText(
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
                            TaTitleLargeText(
                              text: product?.description ?? '',
                              color: context.colorScheme.outline,
                            ),
                            SizedBox(height: 20),
                            _buildDetailRow(
                              'Condition',
                              product?.condition ?? '',
                              context,
                            ),
                            SizedBox(height: 12),
                            _buildDetailRow(
                              'Price Type',
                              product?.priceType ?? '',
                              context,
                            ),
                            SizedBox(height: 12),
                            _buildDetailRow(
                              'Category',
                              product?.categoryType ?? '',
                              context,
                            ),
                            SizedBox(height: 12),
                            _buildDetailRow(
                              'Location',
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TaHeadlineMediumText(
                              text: 'Delivery Options',
                              color: context.colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                            SizedBox(height: 15),
                            _buildDetailRow(
                              'Delivery Details',
                              'Home Delivery Available,\nCash On Delivery',
                              context,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colorScheme.primary,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: TaHeadlineMediumText(
                          text: 'Add To Cart',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
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
          child: TaTitleLargeText(
            text: label,
            color: context.colorScheme.outline,
          ),
        ),
        Expanded(
          flex: 3,
          child: TaTitleLargeText(
            text: value,
            color: context.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
