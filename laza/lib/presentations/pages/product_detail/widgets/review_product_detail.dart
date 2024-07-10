import 'package:flutter/material.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/gen_assets/assets.gen.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/util/functions.dart';
import '../../home/widget/hearder_section.dart';
import 'star_rating.dart';

class ReviewProductDetail extends StatelessWidget {
  const ReviewProductDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                backgroundImage: AssetImage(
                  Assets.images.dataImage.path,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ronald Richards',
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
                      Text('13 Sep, 2020',
                          style: context.textTheme.titleMedium),
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
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque malesuada eget vitae amet...',
              style: context.textTheme.headlineMedium),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
