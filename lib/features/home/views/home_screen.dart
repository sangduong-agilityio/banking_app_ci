import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/home/states/home_cubit.dart';
import 'package:banking_app/features/home/states/home_state.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:banking_app/features/home/widgets/list_view_actions.dart';
import 'package:banking_app/features/home/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<HomeCubit>()..fetchHomeData(),
      child: BAScaffold(
        backgroundColor: context.colorScheme.onPrimary,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<HomeCubit, HomeState>(
                      buildWhen: (previous, current) =>
                          previous.user != current.user,
                      builder: (context, state) {
                        final username = state.user?.username ?? '';
                        return Text(
                          '${S.current.homeGreetingTitle(username)} ',
                          style: context.displayLarge,
                        );
                      },
                    ),
                  ],
                ),

                // Card swiper
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: 220,
                  child: BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (previous, current) =>
                        previous.cards != current.cards,
                    builder: (context, state) {
                      return CardsSwiperWidget<CardModel>(
                        cardData: state.cards,
                        onCardChange: (index) {
                          context.read<HomeCubit>().changeCardIndex(index);
                        },
                        shouldStartCardCollectionAnimation:
                            state.shouldPlayAnimation,
                        onCardCollectionAnimationComplete: (value) {
                          context.read<HomeCubit>().setAnimationStatus(value);
                        },
                        cardBuilder: (context, index, visibleIndex) {
                          final card = state.cards[index];
                          return CreditCard(
                            key: ValueKey<int>(index),
                            data: card,
                            isActive: visibleIndex == 0,
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                // Actions list
                const ListViewActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
