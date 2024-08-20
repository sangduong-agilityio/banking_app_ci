import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laza/core/constant/constants.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/utils/functions.dart';
import 'package:laza/providers/auth_provider.dart';
import '../../home/widgets/hearder_section.dart';
import 'star_rating.dart';

class ReviewProductDetail extends ConsumerWidget {
  const ReviewProductDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsyncValue = ref.watch(userProfileProvider);

    return userProfileAsyncValue.when(
      data: (user) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              HeaderSection(
                title: S.current.reviews,
                color: context.colorScheme.primary,
                isActivateViewAll: true,
                onTap: () {},
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: user?.avatar != null
                        ? NetworkImage(user!.avatar)
                        : null,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.userName ?? '',
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: context.colorScheme.primaryContainer,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_sharp,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            Constants.dateFormat,
                            style: context.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                        S.current.rating(
                          NumberFormatter.formatViewer(5),
                        ),
                        style: context.textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const LSStarRating(
                        rating: 5,
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                user?.review ?? '',
                style: context.textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
