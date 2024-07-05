import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extenssions/context_extenssions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/widgets/app_bar.dart';
import 'package:laza/core/widgets/icons.dart';
import 'package:laza/core/widgets/scaffold.dart';
import 'package:laza/features/home/presentation/widget/search_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LazaShopScaffold(
      paddingScaffold: 20,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 45),
          LSAppBar(
            onTappedBackButton: () => context.pop(),
            icon: LSIcons.icMenu,
            onTappedRightButton: () {},
            rightButtonIcon: LSIcons.icBag,
          ),
          const SizedBox(height: 45),
          Text(
            S.current.hello,
            style: context.textTheme.displayLarge,
          ),
          const SizedBox(height: 5),
          Text(
            S.current.welcomeToLaza,
            style: context.textTheme.headlineMedium!
                .copyWith(color: context.colorScheme.tertiaryContainer),
          ),
          const SizedBox(height: 20),
          const LSSearchBar(),
        ],
      ),
    );
  }
}
