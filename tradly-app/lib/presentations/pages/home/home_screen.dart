import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/core/routes/app_router.dart';
import 'package:tradly_app/data/repositories/home_repo.dart';
import 'package:tradly_app/presentations/layouts/app_bar.dart';
import 'package:tradly_app/presentations/layouts/bottom_navigation_bar.dart';
import 'package:tradly_app/presentations/pages/home/states/home_bloc.dart';
import 'package:tradly_app/presentations/pages/home/states/home_event.dart';
import 'package:tradly_app/presentations/pages/home/views/categories_list.dart';
import 'package:tradly_app/presentations/pages/home/views/header_section.dart';
import 'package:tradly_app/presentations/pages/home/views/new_product_list.dart';
import 'package:tradly_app/presentations/pages/home/views/popular_product_list.dart';
import 'package:tradly_app/presentations/pages/home/views/product_banner_list.dart';
import 'package:tradly_app/presentations/pages/home/views/search_view.dart';
import 'package:tradly_app/presentations/pages/home/views/store_follow_list.dart';
import 'package:tradly_app/presentations/widgets/text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        repo: context.read<HomeRepository>(),
      )..add(HomeInitializeEvt()),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: context.colorScheme.onPrimary,
          appBar: TaAppBar(
            toolbarHeight: TaAppBarSize.medium,
            searchForm: TASearchBar(
              placeholder: S.current.homeSearchProductPlaceholder,
            ),
            bottomType: TaAppBarBottomType.search,
            trailing: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {},
                ),
              ],
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: TaDisplaySmallText(
                text: S.current.homeGroceriesTitle,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const ProductBannerList(),
                CategoriesList(
                  onCategoryTap: (category) {
                    switch (category.category) {
                      case 'Beverages':
                        TARouter.navigateToCategory(
                          context,
                          TAPaths.beverages.name,
                          extra: category.id,
                        );
                        break;
                      case 'Vegetables':
                        TARouter.navigateToCategory(
                          context,
                          TAPaths.vegetables.name,
                          extra: category.id,
                        );
                        break;
                      case 'Bread & Bakery':
                        TARouter.navigateToCategory(
                          context,
                          TAPaths.breadBakely.name,
                          extra: category.id,
                        );
                        break;
                      case 'Egg':
                        TARouter.navigateToCategory(
                          context,
                          TAPaths.egg.name,
                          extra: category.id,
                        );
                        break;
                      case 'Fruits':
                        TARouter.navigateToCategory(
                          context,
                          TAPaths.fruit.name,
                          extra: category.id,
                        );
                        break;
                      case 'Home Care':
                        TARouter.navigateToCategory(
                          context,
                          TAPaths.homeCare.name,
                          extra: category.id,
                        );
                        break;
                      case 'Pet Care':
                        TARouter.navigateToCategory(
                          context,
                          TAPaths.petCare.name,
                          extra: category.id,
                        );
                        break;
                      case 'Frozen Veg':
                        TARouter.navigateToCategory(
                          context,
                          TAPaths.frozenVeg.name,
                          extra: category.id,
                        );
                        break;
                    }
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
          bottomNavigationBar: TABottomNavigationBar(
            items: [
              TASBottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: S.current.homeLabel,
              ),
              TASBottomNavigationBarItem(
                icon: const Icon(Icons.search),
                label: S.current.homeBrowseLabel,
              ),
              TASBottomNavigationBarItem(
                icon: const Icon(Icons.store),
                label: S.current.homeStoreLabel,
              ),
              TASBottomNavigationBarItem(
                icon: const Icon(Icons.history),
                label: S.current.homeOrderHistoryLabel,
              ),
              TASBottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: S.current.homeProfileLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
