import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/presentations/pages/home/states/home_bloc.dart';
import 'package:tradly_app/presentations/pages/home/states/home_state.dart';
import 'package:tradly_app/presentations/widgets/card.dart';
import 'package:tradly_app/presentations/widgets/not_found.dart';
import 'package:tradly_app/presentations/widgets/shimmer.dart';

class NewProductList extends StatelessWidget {
  const NewProductList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.newProducts != current.newProducts,
        builder: (context, state) {
          if (state.status is HomeStatusLoading) {
            return const ShimmerProductList();
          } else if (state.status is HomeStatusSuccess) {
            final newProducts = state.newProducts ?? [];
            return SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: newProducts.length,
                itemBuilder: (context, index) {
                  return TACardProduct(
                    product: newProducts[index],
                    onTapProduct: () {},
                  );
                },
              ),
            );
          } else if (state.status is HomeStatusFailure) {
            return NotFoundScreen();
          }
          return const SizedBox.shrink();
        });
  }
}
