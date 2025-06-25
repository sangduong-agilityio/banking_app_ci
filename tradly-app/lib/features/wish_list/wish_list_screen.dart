import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/features/wish_list/states/wish_list_cubit.dart';
import 'package:tradly_app/features/wish_list/states/wish_list_state.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/utils/responsive.dart';
import 'package:tradly_app/widgets/card.dart';
import 'package:tradly_app/widgets/layouts/app_bar.dart';
import 'package:tradly_app/widgets/layouts/scaffold.dart';
import 'package:tradly_app/widgets/not_found.dart';
import 'package:tradly_app/widgets/shimmer.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishListCubit, WishListState>(
      builder: (context, state) {
        if (state.status is WishListStatusLoading) {
          return ShimmerProductGrid();
        } else if (state.status is WishListStatusSuccess) {
          final wishlist = state.wishlist;
          return TAScaffold(
            appBar: TAAppBar.checkout(
              title: S.current.wishLisTitle,
              onBackPressed: () => Navigator.pop(context),
              backgroundColor: context.colorScheme.primary,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: TAResponsive.orientationSizeOf(
                      context,
                      portrait: 2,
                      landscape: 4,
                    ),
                  ),
                  itemCount: wishlist.length,
                  itemBuilder: (context, index) {
                    final product = wishlist[index];
                    return TACardProduct(
                      product: product,
                      onTapProduct: () {},
                    );
                  },
                ),
              ),
            ),
          );
        } else {
          return const NotFoundScreen();
        }
      },
    );
  }
}
