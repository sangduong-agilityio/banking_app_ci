import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/card.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/home/presentation/blocs/home_cubit.dart';
import 'package:banking_app/features/home/presentation/blocs/home_state.dart';
import 'package:banking_app/features/home/data/models/card_model.dart';
import 'package:banking_app/features/home/presentation/widgets/list_view_actions.dart';
import 'package:banking_app/core/widgets/cards_swiper.dart';
import 'package:banking_app/core/widgets/shimmer.dart';
import 'package:banking_app/features/setting/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<HomeCubit>()..homeInitialize(),
      child: BAScaffold(
        body: Container(
          color: context.colorScheme.secondary,
          child: Column(
            children: const [
              GreetingAppBar(),
              SizedBox(height: 24),
              HomeContent(),
            ],
          ),
        ),
      ),
    );
  }
}

class GreetingAppBar extends StatelessWidget {
  const GreetingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeState, UserModel?>(
      selector: (state) => state.user,
      builder: (context, user) {
        if (user == null) {
          return const GreetingAppBarSkeleton();
        }
        return BAAppBar(
          title: S.current.homeGreetingTitle(user.username ?? ''),
          alignment: BAAppBarAlignment.left,
          profileImage: user.profileImage,
          style: context.titleMedium?.copyWith(
            color: context.colorScheme.onPrimary,
          ),
          titleColor: context.colorScheme.onPrimary,
          showBackButton: false,
          backgroundColor: context.colorScheme.secondary,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              color: context.colorScheme.onPrimary,
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.colorScheme.onPrimary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: const [
                SizedBox(height: 20),
                CreditCardsSwiper(),
                SizedBox(height: 24),
                HomeActionsGrid(),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreditCardsSwiper extends StatelessWidget {
  const CreditCardsSwiper({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 204,
      child: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) =>
            previous.cards != current.cards ||
            previous.isBalanceVisible != current.isBalanceVisible,
        builder: (context, state) {
          final cards = state.cards;
          final shouldPlayAnimation = state.shouldPlayAnimation;
          final isBalanceVisible = state.isBalanceVisible;

          if (cards.isEmpty) {
            return Row(children: const [Expanded(child: BACardSkeleton())]);
          }

          return CardsSwiperWidget<CardModel>(
            cardData: cards,
            onCardChange: (index) {
              context.read<HomeCubit>().changeCardIndex(index);
            },
            shouldStartCardCollectionAnimation: shouldPlayAnimation,
            onCardCollectionAnimationComplete: (value) {
              context.read<HomeCubit>().setAnimationStatus(value);
            },
            cardBuilder: (context, index, visibleIndex) {
              final card = cards[index];
              return SwipeableCreditCard(
                key: ValueKey<String>('card-$index-$isBalanceVisible'),
                data: card,
                isActive: visibleIndex == 0,
                isBalanceVisible: isBalanceVisible,
                onToggleVisibility: () {
                  context.read<HomeCubit>().toggleBalanceVisibility();
                },
              );
            },
          );
        },
      ),
    );
  }
}

class HomeActionsGrid extends StatelessWidget {
  const HomeActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeState, HomeStatus>(
      selector: (state) => state.status,
      builder: (context, status) {
        if (status == HomeStatus.loading) {
          return const BAGridSkeleton();
        }
        return const ListViewActions();
      },
    );
  }
}
