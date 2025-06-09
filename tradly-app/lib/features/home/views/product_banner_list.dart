import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/features/home/states/home_bloc.dart';
import 'package:tradly_app/features/home/states/home_state.dart';
import 'package:tradly_app/widgets/not_found.dart';
import 'package:tradly_app/widgets/shimmer.dart';
import 'package:tradly_app/widgets/text.dart';

class ProductBannerList extends StatelessWidget {
  const ProductBannerList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.banners != current.banners,
        builder: (context, state) {
          if (state.status is HomeStatusLoading) {
            return ShimmerHeroBanner();
          } else if (state.status is HomeStatusSuccess) {
            return SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: state.banners?.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 16,
                      bottom: 16,
                    ),
                    child: Container(
                      width: 300,
                      height: 165,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: context.colorScheme.primary,
                        image: DecorationImage(
                          image: NetworkImage(
                              state.banners?[index].imageUrl ?? ''),
                          fit: BoxFit.cover,
                          onError: (error, stackTrace) {},
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 50),
                          Padding(
                            padding: const EdgeInsets.only(left: 17),
                            child: TATitleLargeText(
                              text: state.banners?[index].title ?? '',
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.onPrimary,
                              letterSpacing: 1.22,
                              height: 16 / 14,
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: context.colorScheme.onPrimary,
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: TATitleMediumText(
                                text: state.banners?[index].buttonText ?? '',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
