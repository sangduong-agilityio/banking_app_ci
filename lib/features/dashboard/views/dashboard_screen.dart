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
  late AnimationController _pageAnimationController;

  bool _shouldPlayAnimation = false;
  int currentCardIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageAnimationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _pageAnimationController.forward();
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
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
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<DashBoardCubit, DashBoardState>(
                        builder: (context, state) {
                          return Text(
                            '${S.current.homegreetingTitle}${state.user?.username}',
                            style: context.displayLarge,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: BlocBuilder<DashBoardCubit, DashBoardState>(
                    builder: (context, state) {
                      return CardsSwiperWidget<CardModel>(
                        cardData: state.cards,
                        animationDuration: Duration(milliseconds: 600),
                        downDragDuration: Duration(milliseconds: 200),
                        topCardOffsetStart: 0.0,
                        topCardOffsetEnd: 0.0,
                        topCardScaleStart: 1.0,
                        topCardScaleEnd: 1.0,
                        secondCardOffsetStart: 8.0,
                        secondCardOffsetEnd: 0.0,
                        secondCardScaleStart: 0.96,
                        secondCardScaleEnd: 1.0,
                        thirdCardOffsetStart: 16.0,
                        thirdCardOffsetEnd: 8.0,
                        thirdCardScaleStart: 0.92,
                        thirdCardScaleEnd: 0.96,
                        onCardChange: (index) {
                          setState(() {
                            currentCardIndex = index;
                          });
                        },
                        shouldStartCardCollectionAnimation:
                            _shouldPlayAnimation,
                        onCardCollectionAnimationComplete: (value) {
                          setState(() {
                            _shouldPlayAnimation = value;
                          });
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
                ListViewActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
