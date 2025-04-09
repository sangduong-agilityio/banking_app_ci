import 'package:flutter/material.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/data/models/category_model.dart';
import 'package:tradly_app/presentations/layouts/bottom_navigation_bar.dart';
import 'package:tradly_app/presentations/pages/home/views/categories_list.dart';
import 'package:tradly_app/presentations/pages/home/views/header_section.dart';
import 'package:tradly_app/presentations/pages/home/views/new_product_list.dart';
import 'package:tradly_app/presentations/pages/home/views/popular_product_list.dart';
import 'package:tradly_app/presentations/pages/home/views/product_banner_list.dart';
import 'package:tradly_app/presentations/pages/home/views/search_view.dart';
import 'package:tradly_app/presentations/layouts/app_bar.dart';
import 'package:tradly_app/presentations/pages/home/views/store_follow_list.dart';
import 'package:tradly_app/presentations/widgets/text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                  icon: Icon(
                    Icons.favorite,
                  ),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                  ),
                  onPressed: () {}),
            ],
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TaDisplaySmallText(
              text: 'Groceries',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ProductBannerList(),
              CategoriesList(
                category: CategoryModel(
                  id: '1',
                  category: 'Vegetable',
                  imageUrl: 'assets/images/shopping.png',
                ),
              ),
              SizedBox(height: 28),
              HomeSectionHeader(
                title: S.current.homeNewProductTitle,
                onTap: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: NewProductList(),
              ),
              SizedBox(height: 16),
              HomeSectionHeader(
                title: S.current.homePopularProductTitle,
                onTap: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: PopularProductList(),
              ),
              SizedBox(height: 30),
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
                  Positioned(
                    top: 50,
                    left: 20,
                    child: StoreFollowList(),
                  ),
                ],
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
        bottomNavigationBar: TABottomNavigationBar(
          items: [
            TASBottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: S.current.homeLabel,
            ),
            TASBottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: S.current.homeBrowseLabel,
            ),
            TASBottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: S.current.homeStoreLabel,
            ),
            TASBottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: S.current.homeOrderHistoryLabel,
            ),
            TASBottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: S.current.homeProfileLabel,
            ),
          ],
        ),
      ),
    );
  }
}
