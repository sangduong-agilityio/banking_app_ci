import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/features/browse/repositories/browse_repo.dart';
import 'package:tradly_app/utils/locator.dart';
import 'package:tradly_app/utils/responsive.dart';
import 'package:tradly_app/widgets/layouts/app_bar.dart';
import 'package:tradly_app/widgets/layouts/scaffold.dart';
import 'package:tradly_app/features/browse/states/browse_bloc.dart';
import 'package:tradly_app/features/browse/states/browse_event.dart';
import 'package:tradly_app/features/browse/states/browse_state.dart';
import 'package:tradly_app/features/home/views/search_view.dart';
import 'package:tradly_app/widgets/assets.dart';
import 'package:tradly_app/widgets/card.dart';
import 'package:tradly_app/widgets/not_found.dart';
import 'package:tradly_app/widgets/shimmer.dart';
import 'package:tradly_app/widgets/text.dart';
import 'package:tradly_app/widgets/bottom_sheet.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  @override
  Widget build(BuildContext context) {
    final crossAxisCount = TAResponsive.orientationSizeOf(
      context,
      portrait: 2,
      landscape: 4,
    );
    return BlocProvider(
      create: (context) => BrowseBloc(
        repo: locator.get<BrowseRepository>(),
      )..add(const BrowseInitializeEvt()),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: TAScaffold(
          appBar: TAAppBar(
            toolbarHeight: TAAppBarSize.large,
            centerTitle: false,
            title: TADisplaySmallText(
              text: S.current.browseTitle,
              fontWeight: FontWeight.w700,
            ),
            trailing: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {},
                ),
                TAAssets.cart(),
              ],
            ),
            searchForm: BlocBuilder<BrowseBloc, BrowseState>(
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                return TASearchView(
                  onChanged: (query) {
                    context
                        .read<BrowseBloc>()
                        .add(BrowseSearchEvt(query: query));
                  },
                  placeholder: S.current.homeSearchProductPlaceholder,
                );
              },
            ),
            filterOptions: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BlocBuilder<BrowseBloc, BrowseState>(
                    buildWhen: (previous, current) =>
                        previous.status != current.status,
                    builder: (context, state) {
                      return _buildFilterButton(
                        context,
                        icon: TAAssets.sortList(),
                        label: S.current.productDetailSortByButton,
                        onPressed: () => showSortBottomSheet(context),
                      );
                    },
                  ),
                  _buildFilterButton(
                    context,
                    icon: const Icon(
                      Icons.location_on,
                      size: 16,
                    ),
                    label: S.current.productDetailLocationButton,
                    onPressed: () {},
                  ),
                  _buildFilterButton(
                    context,
                    icon: TAAssets.category(),
                    label: S.current.productDetailCategoryButton,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            bottomType: TAAppBarBottomType.custom,
          ),
          body: BlocBuilder<BrowseBloc, BrowseState>(
            builder: (context, state) {
              if (state.status is BrowseStatusLoading) {
                return ShimmerProductGrid();
              } else if (state.status is BrowseStatusSuccess) {
                final products = state.products ?? [];
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount.toInt(),
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return TACardProduct(
                          product: product,
                          onTapProduct: () {},
                        );
                      },
                    ),
                  ),
                );
              } else if (state.status is BrowseStatusFailure) {
                return NotFoundScreen();
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  void showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (BuildContext modalContext) {
        return TABottomSheet(
          initialSortOrder: SortOrder.lowToHigh,
          onApply: (SortOrder selectedSortOrder) {
            context.read<BrowseBloc>().add(
                  BrowseSortEvt(sort: selectedSortOrder),
                );
          },
        );
      },
    );
  }

  Widget _buildFilterButton(
    BuildContext context, {
    required Widget icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: TATitleLargeText(
        text: label,
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(
            color: context.colorScheme.onPrimary,
            width: 1,
          ),
        ),
      ),
    );
  }
}
