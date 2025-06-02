import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/features/home/states/home_bloc.dart';
import 'package:tradly_app/features/home/states/home_state.dart';
import 'package:tradly_app/widgets/card.dart';
import 'package:tradly_app/widgets/not_found.dart';
import 'package:tradly_app/widgets/shimmer.dart';

class PopularProductList extends StatelessWidget {
  const PopularProductList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.popularProducts != current.popularProducts,
      builder: (context, state) {
        if (state.status is HomeStatusLoading) {
          return ShimmerProductList();
        } else if (state.status is HomeStatusSuccess) {
          final popularProducts = state.popularProducts ?? [];
          return SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popularProducts.length,
              itemBuilder: (context, index) {
                return TACardProduct(
                  product: popularProducts[index],
                  onTapProduct: () {},
                );
              },
            ),
          );
        } else if (state.status is HomeStatusFailure) {
          return NotFoundScreen();
        }
        return const SizedBox.shrink();
      },
    );
  }
}
