import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/assets_generated/assets.gen.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/presentations/layouts/app_bar.dart';
import 'package:tradly_app/presentations/layouts/bottom_navigation_bar.dart';
import 'package:tradly_app/presentations/pages/store/states/store_bloc.dart';
import 'package:tradly_app/presentations/pages/store/states/store_state.dart';
import 'package:tradly_app/presentations/pages/store/views/add_product.dart';
import 'package:tradly_app/presentations/pages/store/views/add_product_cart.dart';
import 'package:tradly_app/presentations/pages/store/views/create_store.dart';
import 'package:tradly_app/presentations/pages/store/views/edit_product.dart';
import 'package:tradly_app/presentations/widgets/assets.dart';
import 'package:tradly_app/presentations/widgets/card.dart';
import 'package:tradly_app/presentations/widgets/images.dart';
import 'package:tradly_app/presentations/widgets/text.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.inversePrimary,
      appBar: TaAppBar(
        toolbarHeight: TaAppBarSize.small,
        bottomType: TaAppBarBottomType.none,
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: TaDisplaySmallText(
            text: S.current.storeTitle,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        backgroundColor: context.colorScheme.primary,
        trailing: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {},
              ),
              IconButton(
                icon: TAAssets.cart(),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<StoreBloc, StoreState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.stores != current.stores ||
            previous.products != current.products,
        builder: (context, state) {
          if (state.status is StoreStatusLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: context.colorScheme.primary,
              ),
            );
          }
          return state.hasStore
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        color: context.colorScheme.onPrimary,
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            Center(
                              child: TAImageCircle(
                                radius: 32,
                                Assets.images.imgTradly.path,
                                boxFit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TaDisplaySmallText(
                              text: state.stores?.name ?? '',
                              fontWeight: FontWeight.w700,
                              color: context.colorScheme.onSurface,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(100, 25),
                                    side: BorderSide(
                                      color: context.colorScheme.primary,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                  ),
                                  child: TaTitleMediumText(
                                    text: 'Edit Store',
                                    color: context.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(100, 25),
                                    side: BorderSide(
                                      color: context.colorScheme.primary,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                  ),
                                  child: TaTitleMediumText(
                                    text: 'View Store',
                                    color: context.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Divider(color: Colors.grey[300]),
                            TextButton(
                              onPressed: () {},
                              child: TaTitleLargeText(
                                text: 'Remove Store',
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                      state.hasProducts
                          ? _buildProductsList(context, state)
                          : _buildNoProductsContent(),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        height: 120,
                        Assets.images.imgEmptyStore.path,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 30),
                      TaHeadlineMediumText(
                        text: S.current.storeNoStore,
                        color: context.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 37),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: context.read<StoreBloc>(),
                                child: const CreateStoreScreen(),
                              ),
                            ),
                          ).then((value) {
                            if (value == true) {}
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: TaHeadlineMediumText(
                          text: S.current.storeCreateStoreButton,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildNoProductsContent() {
    return Column(
      children: [
        TaHeadlineMediumText(
          text: S.current.storeNoProduct,
          fontWeight: FontWeight.w600,
          color: context.colorScheme.onSurface,
        ),
        const SizedBox(height: 40),
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddProductScreen()),
            ).then((value) {
              if (value == true) {}
            });
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: context.colorScheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 12,
            ),
          ),
          child: TaHeadlineMediumText(
            text: S.current.storeAddProductButton,
            fontWeight: FontWeight.w600,
            color: context.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildProductsList(
    BuildContext context,
    StoreState state,
  ) {
    final products = state.products ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TaHeadlineMediumText(
            text: S.current.storeProductsTitle,
            fontWeight: FontWeight.w600,
            color: context.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length + 1,
            itemBuilder: (context, index) {
              if (index == products.length) {
                return AddProductCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddProductScreen(),
                      ),
                    );
                  },
                );
              } else {
                final product = products[index];
                return TACardProduct(
                  product: product,
                  onTapProduct: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProductScreen(
                          product: product,
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return TABottomNavigationBar(currentIndex: 2);
  }
}
