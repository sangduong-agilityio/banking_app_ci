import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extenssions/context_extenssions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/core/widgets/app_bar.dart';
import 'package:laza/core/widgets/drawer_menu.dart';
import 'package:laza/core/widgets/icons.dart';
import 'package:laza/features/home/presentation/widget/list_view_brand.dart';
import 'package:laza/features/home/presentation/widget/hearder_section.dart';
import 'package:laza/features/home/presentation/widget/grid_view_products.dart';
import 'package:laza/features/home/presentation/widget/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    const sizeBox20 = SizedBox(height: 20);
    const sizeBox15 = SizedBox(height: 15);
    return Scaffold(
      backgroundColor: context.colorScheme.onPrimary,
      key: _scaffoldKey,
      drawer: const LSDrawerMenu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 45),
              LSAppBar(
                onTappedBackButton: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                icon: LSIcons.icMenu,
                onTappedRightButton: () {},
                rightButtonIcon: LSIcons.icBag,
              ),
              const SizedBox(height: 30),
              Text(
                S.current.hello,
                style: context.textTheme.displayLarge,
              ),
              const SizedBox(height: 5),
              Text(
                S.current.welcomeToLaza,
                style: context.textTheme.headlineMedium!.copyWith(
                  color: context.colorScheme.tertiaryContainer,
                ),
              ),
              sizeBox20,
              const LSSearchBar(),
              sizeBox20,
              HeaderSection(
                title: S.current.chooseBrand,
                isActivateViewAll: true,
                color: context.colorScheme.tertiaryContainer,
                onTap: () {
                  context.pushNamed(
                    AppRoutesName.productDetailScreen.name,
                    extra: e,
                  );
                },
              ),
              sizeBox15,
              const ListViewBrand(),
              sizeBox15,
              HeaderSection(
                title: S.current.newArraival,
                color: context.colorScheme.tertiaryContainer,
                isActivateViewAll: true,
                onTap: () {
                  context.pushNamed(
                    AppRoutesName.brandDetailScreen.name,
                    extra: e,
                  );
                },
              ),
              const GridViewProduct()
            ],
          ),
        ),
      ),
    );
  }
}
