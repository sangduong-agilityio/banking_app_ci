import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/presentations/pages/home/states/home_bloc.dart';
import 'package:tradly_app/presentations/pages/home/states/home_state.dart';
import 'package:tradly_app/presentations/widgets/card.dart';
import 'package:tradly_app/presentations/widgets/not_found.dart';

class StoreFollowList extends StatelessWidget {
  const StoreFollowList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.stores != current.stores,
        builder: (context, state) {
          if (state.status is HomeStatusLoading) {
            return const CircularProgressIndicator();
          } else if (state.status is HomeStatusSuccess) {
            final stores = state.stores ?? [];
            return SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  return TACardStoreFollow(
                    stores: stores[index],
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
