import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tradly_app/configs/app_router.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/features/home/repositories/home_repo.dart';
import 'package:tradly_app/features/home/states/home_bloc.dart';
import 'package:tradly_app/features/home/states/home_event.dart';
import 'package:tradly_app/features/home/views/categories_list.dart';
import 'package:tradly_app/features/home/views/header_section.dart';
import 'package:tradly_app/features/home/views/new_product_list.dart';
import 'package:tradly_app/features/home/views/popular_product_list.dart';
import 'package:tradly_app/features/home/views/product_banner_list.dart';
import 'package:tradly_app/features/home/views/search_view.dart';
import 'package:tradly_app/features/home/views/see_all_new_product.dart';
import 'package:tradly_app/features/home/views/see_all_popular_product.dart';
import 'package:tradly_app/features/home/views/store_follow_list.dart';
import 'package:tradly_app/features/home/views/view_all_store.dart';
import 'package:tradly_app/features/product_detail/views/product_list.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/utils/locator.dart';
import 'package:tradly_app/widgets/assets.dart';
import 'package:tradly_app/widgets/layouts/scaffold.dart';
import 'package:tradly_app/widgets/text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.productId});

  final int? productId;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        repo: locator.get<HomeRepository>(),
      )..add(HomeInitializeEvt(productId: widget.productId ?? 0)),
      child: TAScaffold(
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 180,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 40, 10, 0),
                          child: Row(
                            children: [
                              TADisplaySmallText(
                                text: S.current.homeGroceriesTitle,
                                fontWeight: FontWeight.w700,
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon(Icons.favorite,
                                    color: context.colorScheme.onPrimary),
                                onPressed: () {
                                  context.pushNamed(
                                    TAPaths.wishList.name,
                                  );
                                },
                              ),
                              TAAssets.cart(),
                              const SizedBox(width: 20),
                            ],
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, 10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            child: SearchSpotlight(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const ProductBannerList(),
                      CategoriesList(
                        onCategoryTap: (category) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductList(
                                title: category.category ?? '',
                                categoryId: category.id ?? 0,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 28),
                      HomeSectionHeader(
                        title: S.current.homeNewProductTitle,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeeAllNewProductScreen(
                                title: S.current.homeNewProductTitle,
                                productId: widget.productId ?? 0,
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: NewProductList(),
                      ),
                      const SizedBox(height: 16),
                      HomeSectionHeader(
                        title: S.current.homePopularProductTitle,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeeAllPopularProductScreen(
                                title: S.current.homePopularProductTitle,
                                productId: widget.productId ?? 0,
                              ),
                            ),
                          );
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: PopularProductList(),
                      ),
                      const SizedBox(height: 30),
                      Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 184,
                            width: double.infinity,
                            color: context.colorScheme.primary,
                            child: Column(
                              children: [
                                HomeSectionHeader(
                                  title: S.current.homeStoreToFolowTitle,
                                  textColor: context.colorScheme.onPrimary,
                                  buttonColor: context.colorScheme.onPrimary,
                                  buttonText: S.current.homeViewAllButton,
                                  buttonTextColor: context.colorScheme.primary,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ViewAllStoreScreen(
                                          title: S.current.homeStoreLabel,
                                          productId: widget.productId ?? 0,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Positioned(
                            top: 50,
                            left: 15,
                            right: 0,
                            child: StoreFollowList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
