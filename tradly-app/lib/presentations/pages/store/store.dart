import 'package:flutter/material.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/assets_generated/assets.gen.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/presentations/layouts/app_bar.dart';
import 'package:tradly_app/presentations/layouts/bottom_navigation_bar.dart';
import 'package:tradly_app/presentations/pages/store/views/add_product.dart';
import 'package:tradly_app/presentations/pages/store/views/add_product_cart.dart';
import 'package:tradly_app/presentations/pages/store/views/card.dart';
import 'package:tradly_app/presentations/pages/store/views/create_store.dart';
import 'package:tradly_app/presentations/pages/store/views/edit_product.dart';
import 'package:tradly_app/presentations/widgets/assets.dart';
import 'package:tradly_app/presentations/widgets/images.dart';
import 'package:tradly_app/presentations/widgets/text.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  bool hasStore = false;
  bool hasProducts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.inversePrimary,
      appBar: TaAppBar(
        toolbarHeight: TaAppBarSize.small,
        bottomType: TaAppBarBottomType.none,
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: const TaDisplaySmallText(
            text: 'My Store',
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
      body: hasStore
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
                          text: 'Tradly Store',
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                          onPressed: () {
                            setState(() {
                              hasStore = false;
                            });
                          },
                          child: TaTitleLargeText(
                            text: 'Remove Store',
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  hasProducts
                      ? _buildProductsList()
                      : _buildNoProductsContent(),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.images.imgEmptyStore.path,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 30),
                  TaHeadlineMediumText(
                    text: "You Don't Have a Store",
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 37),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateStoreScreen(),
                        ),
                      ).then((value) {
                        if (value == true) {
                          setState(() {
                            hasStore = true;
                          });
                        }
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
                    child: const Text(
                      'Create Store',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildNoProductsContent() {
    return Column(
      children: [
        TaHeadlineMediumText(
          text: 'You dont have product',
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
              if (value == true) {
                setState(() {
                  hasProducts = true;
                });
              }
            });
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: context.colorScheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          ),
          child: TaTitleMediumText(
            text: 'Add Product',
            color: context.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildProductsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Products',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Product card
              Expanded(
                child: ProductCard(
                  name: 'Broccoli',
                  price: 30,
                  storeName: 'Tradly',
                  imageUrl: 'assets/images/broccoli.jpg',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProductScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Add product placeholder
              Expanded(
                child: AddProductCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddProductScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return TABottomNavigationBar(
      items: [
        TASBottomNavigationBarItem(
          icon: TAAssets.home(),
          label: S.current.homeLabel,
          activeIcon: TAAssets.home(
            color: context.colorScheme.primary,
          ),
        ),
        TASBottomNavigationBarItem(
          icon: TAAssets.search(),
          label: S.current.homeBrowseLabel,
          activeIcon: TAAssets.search(
            color: context.colorScheme.primary,
          ),
        ),
        TASBottomNavigationBarItem(
          icon: TAAssets.store(),
          label: S.current.homeStoreLabel,
          activeIcon: TAAssets.store(
            color: context.colorScheme.primary,
          ),
        ),
        TASBottomNavigationBarItem(
          icon: TAAssets.order(),
          label: S.current.homeOrderHistoryLabel,
          activeIcon: TAAssets.order(
            color: context.colorScheme.primary,
          ),
        ),
        TASBottomNavigationBarItem(
          icon: TAAssets.profile(),
          label: S.current.homeProfileLabel,
          activeIcon: TAAssets.profile(
            color: context.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
