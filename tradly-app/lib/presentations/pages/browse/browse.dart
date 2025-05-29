import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/data/repositories/browse_repo.dart';
import 'package:tradly_app/presentations/layouts/app_bar.dart';
import 'package:tradly_app/presentations/layouts/scaffold.dart';
import 'package:tradly_app/presentations/pages/browse/states/browse_bloc.dart';
import 'package:tradly_app/presentations/pages/browse/states/browse_event.dart';
import 'package:tradly_app/presentations/pages/browse/states/browse_state.dart';
import 'package:tradly_app/presentations/pages/home/views/search_view.dart';
import 'package:tradly_app/presentations/widgets/assets.dart';
import 'package:tradly_app/presentations/widgets/card.dart';
import 'package:tradly_app/presentations/widgets/not_found.dart';
import 'package:tradly_app/presentations/widgets/shimmer.dart';
import 'package:tradly_app/presentations/widgets/text.dart';
import 'package:tradly_app/presentations/widgets/bottom_sheet.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final bool isPortrait = true;

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = isPortrait ? 8 : 8;
    return BlocProvider(
      create: (context) => BrowseBloc(repo: context.read<BrowseRepository>())
        ..add(const BrowseInitializeEvt()),
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
            filterOptions: Row(
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
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (crossAxisCount * 60),
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
