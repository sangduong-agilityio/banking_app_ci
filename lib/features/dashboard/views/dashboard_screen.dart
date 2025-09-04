import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:banking_app/features/dashboard/bloc/dashboard_state.dart';
import 'package:banking_app/features/dashboard/models/card_model.dart';
import 'package:banking_app/features/dashboard/widgets/list_view_actions.dart';
import 'package:banking_app/features/dashboard/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with TickerProviderStateMixin {
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
      create: (_) => locator<DashBoardCubit>()..fetchDashboardData(),
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
                    BlocBuilder<DashBoardCubit, DashBoardState>(
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
                  child: BlocBuilder<DashBoardCubit, DashBoardState>(
                    buildWhen: (previous, current) =>
                        previous.cards != current.cards,
                    builder: (context, state) {
                      return CardsSwiperWidget<CardModel>(
                        cardData: state.cards,
                        onCardChange: (index) {
                          context.read<DashBoardCubit>().changeCardIndex(index);
                        },
                        shouldStartCardCollectionAnimation:
                            state.shouldPlayAnimation,
                        onCardCollectionAnimationComplete: (value) {
                          context.read<DashBoardCubit>().setAnimationStatus(
                            value,
                          );
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
