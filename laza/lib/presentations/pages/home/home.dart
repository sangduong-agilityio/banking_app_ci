import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/drawer_menu.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'widget/grid_view_products.dart';
import 'widget/hearder_section.dart';
import 'widget/list_view_brand.dart';
import 'widget/search_bar.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const sizeBox20 = SizedBox(height: 20);
    const sizeBox15 = SizedBox(height: 15);

    return Scaffold(
      backgroundColor: context.colorScheme.onPrimary,
      key: _scaffoldKey,
      drawer: const LSDrawerMenu(),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25.h),
                LSAppBar(
                  onTappedBackButton: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  icon: LSIcons.icMenu,
                  onTappedRightButton: () {
                    context.pushNamed(AppRoutesName.cartProductPage.name);
                  },
                  rightButtonIcon: LSIcons.icBag,
                ),
                SizedBox(height: 30.h),
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
                LSSearchBar(
                  controller: _searchController,
                ),
                sizeBox20,
                HeaderSection(
                  title: S.current.chooseBrand,
                  isActivateViewAll: true,
                  color: context.colorScheme.tertiaryContainer,
                  onTap: () {
                    context.pushNamed(
                      AppRoutesName.brandViewAll.name,
                    );
                  },
                ),
                sizeBox15,
                const ListViewBrand(),
                sizeBox15,
                HeaderSection(
                  title: S.current.newArrival,
                  color: context.colorScheme.tertiaryContainer,
                  isActivateViewAll: true,
                  onTap: () {
                    context.pushNamed(
                      AppRoutesName.allListProduct.name,
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: _searchController,
                  builder: (context, value, child) {
                    return GridViewProduct(
                      searchQuery: _searchController.text,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
