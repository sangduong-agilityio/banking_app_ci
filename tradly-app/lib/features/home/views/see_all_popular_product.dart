import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/features/home/states/home_bloc.dart';
import 'package:tradly_app/features/home/states/home_event.dart';
import 'package:tradly_app/features/home/states/home_state.dart';
import 'package:tradly_app/features/home/repositories/home_repo.dart';
import 'package:tradly_app/utils/locator.dart';
import 'package:tradly_app/utils/responsive.dart';
import 'package:tradly_app/widgets/card.dart';
import 'package:tradly_app/widgets/layouts/app_bar.dart';
import 'package:tradly_app/widgets/layouts/scaffold.dart';
import 'package:tradly_app/widgets/not_found.dart';
import 'package:tradly_app/widgets/shimmer.dart';

class SeeAllPopularProductScreen extends StatelessWidget {
  const SeeAllPopularProductScreen({
    super.key,
    required this.title,
    required this.productId,
  });

  final String title;
  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        repo: locator.get<HomeRepository>(),
      )..add(
          HomeInitializeEvt(productId: productId),
        ),
      child: TAScaffold(
        appBar: TAAppBar.productList(
          backgroundColor: context.colorScheme.primary,
          title: title,
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) =>
              previous.status != current.status ||
              previous.popularProducts != current.popularProducts,
          builder: (context, state) {
            if (state.status is HomeStatusLoading) {
              return ShimmerProductGrid();
            } else if (state.status is HomeStatusSuccess) {
              final popularProducts = state.popularProducts ?? [];
              return Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: TAResponsive.orientationSizeOf(
                      context,
                      portrait: 2,
                      landscape: 4,
                    ),
                  ),
                  itemCount: popularProducts.length,
                  itemBuilder: (context, index) {
                    return TACardProduct(
                      product: popularProducts[index],
                    );
                  },
                ),
              );
            } else if (state.status is HomeStatusFailure) {
              return NotFoundScreen();
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
