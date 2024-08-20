import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/drawer_menu.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/providers/product_provider.dart';
import 'widgets/grid_view_product.dart';
import 'widgets/hearder_section.dart';
import 'widgets/list_view_brand.dart';
import 'widgets/search_bar.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.colorScheme.onPrimary,
      drawer: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return const LSDrawerMenu();
          } else {
            return SizedBox.shrink();
          }
        },
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _buildMainContent(context, ref);
          } else {
            return Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: LSDrawerMenu(),
                ),
                Expanded(
                  flex: 4,
                  child: _buildMainContent(context, ref),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.read(productsNotifierProvider('').notifier).refreshProducts('');
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25.h),
              LSAppBar(
                onTappedBackButton: () {
                  if (MediaQuery.of(context).orientation ==
                      Orientation.portrait) {
                    Scaffold.of(context).openDrawer();
                  }
                },
                icon: LSIcons.icMenu,
                onTappedRightButton: () {
                  context.go(AppRoutesName.cartProductPage.path);
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
              const SizedBox(height: 20),
              LSSearchBar(controller: _searchController),
              const SizedBox(height: 20),
              HeaderSection(
                title: S.current.chooseBrand,
                isActivateViewAll: true,
                color: context.colorScheme.tertiaryContainer,
                onTap: () {
                  context.pushNamed(AppRoutesName.brandViewAllPage.name);
                },
              ),
              const SizedBox(height: 15),
              const ListViewBrand(),
              const SizedBox(height: 15),
              HeaderSection(
                title: S.current.newArrival,
                color: context.colorScheme.tertiaryContainer,
                isActivateViewAll: true,
                onTap: () {
                  context.pushNamed(AppRoutesName.allListProductPage.name);
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
    );
  }
}
