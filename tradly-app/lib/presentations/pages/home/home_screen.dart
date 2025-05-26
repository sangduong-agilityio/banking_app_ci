import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/data/repositories/home_repo.dart';
import 'package:tradly_app/presentations/layouts/scaffold.dart';
import 'package:tradly_app/presentations/pages/home/states/home_bloc.dart';
import 'package:tradly_app/presentations/pages/home/states/home_event.dart';
import 'package:tradly_app/presentations/pages/home/views/categories_list.dart';
import 'package:tradly_app/presentations/pages/home/views/header_section.dart';
import 'package:tradly_app/presentations/pages/home/views/new_product_list.dart';
import 'package:tradly_app/presentations/pages/home/views/popular_product_list.dart';
import 'package:tradly_app/presentations/pages/home/views/product_banner_list.dart';
import 'package:tradly_app/presentations/pages/home/views/search_view.dart';
import 'package:tradly_app/presentations/pages/home/views/store_follow_list.dart';
import 'package:tradly_app/presentations/pages/product_detail/views/product_list.dart';
import 'package:tradly_app/presentations/widgets/assets.dart';
import 'package:tradly_app/presentations/widgets/text.dart';

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
        repo: context.read<HomeRepository>(),
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
                                onPressed: () {},
                              ),
                              TAAssets.cart(),
                              const SizedBox(width: 20),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: TASearchView(
                            placeholder: S.current.homeSearchProductPlaceholder,
                          ),
                        ),
                      ],
                    ))),
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
                        onTap: () {},
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: NewProductList(),
                      ),
                      const SizedBox(height: 16),
                      HomeSectionHeader(
                        title: S.current.homePopularProductTitle,
                        onTap: () {},
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
                                  onTap: () {},
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
