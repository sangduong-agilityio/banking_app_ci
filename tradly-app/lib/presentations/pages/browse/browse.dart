import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/data/models/product_model.dart';
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
            searchForm: TASearchView(
              onChanged: (query) {
                context.read<BrowseBloc>().add(
                      BrowseSearchEvt(
                        query: query,
                      ),
                    );
              },
              placeholder: S.current.homeSearchProductPlaceholder,
            ),
            bottomType: TAAppBarBottomType.custom,
          ),
          body: BlocBuilder<BrowseBloc, BrowseState>(
            builder: (context, state) {
              if (state.status is BrowseStatusLoading) {
                return ShimmerProductGrid();
              } else if (state.status is BrowseStatusSuccess) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (crossAxisCount * 60),
                    ),
                    itemCount: state.products?.length ?? 0,
                    itemBuilder: (context, index) {
                      final products = state.products?[index];
                      return TACardProduct(
                        product: ProductModel(
                          id: products?.id,
                          title: products?.title ?? '',
                          imageUrl: products?.imageUrl ?? '',
                          price: products?.price ?? '',
                          brand: products?.brand ?? '',
                        ),
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
}
