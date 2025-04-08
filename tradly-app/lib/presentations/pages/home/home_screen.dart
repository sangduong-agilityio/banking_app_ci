import 'package:flutter/material.dart';
import 'package:tradly_app/presentations/pages/home/views/categories_list.dart';
import 'package:tradly_app/presentations/pages/home/views/product_banner_list.dart';
import 'package:tradly_app/presentations/pages/home/views/search_view.dart';
import 'package:tradly_app/presentations/layouts/app_bar.dart';
import 'package:tradly_app/presentations/layouts/bottom_navigation_bar.dart';
import 'package:tradly_app/presentations/widgets/text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TaAppBar(
          toolbarHeight: TaAppBarSize.medium,
          searchForm: TASearchBar(
            placeholder: 'Search Product',
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
              CategoriesList(),
            ],
          ),
        ),
        bottomNavigationBar: TABottomNavigationBar(
          items: [
            TASBottomNavigationBarItem(
              icon: Icon(Icons.home),
            ),
            TASBottomNavigationBarItem(
              icon: Icon(Icons.home),
            ),
            TASBottomNavigationBarItem(
              icon: Icon(Icons.home),
            ),
            TASBottomNavigationBarItem(
              icon: Icon(Icons.home),
            ),
          ],
        ));
  }
}
