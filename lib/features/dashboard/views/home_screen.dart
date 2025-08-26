import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/dashboard/widgets/list_view_actions.dart';
import 'package:banking_app/features/dashboard/widgets/account_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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
    return BAScaffold(
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
                    Text(
                      '${S.current.homegreetingTitle}\nGega!',
                      style: context.displayLarge,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 220,
                child: CardsSwiperWidget<CardData>(
                  cardData: cards,
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
                  shouldStartCardCollectionAnimation: _shouldPlayAnimation,
                  onCardCollectionAnimationComplete: (value) {
                    setState(() {
                      _shouldPlayAnimation = value;
                    });
                  },
                  cardBuilder: (context, index, visibleIndex) {
                    if (index < 0 || index >= cards.length) {
                      return const SizedBox.shrink();
                    }
                    final card = cards[index];
                    return CreditCard(
                      key: ValueKey<int>(index),
                      data: card,
                      isActive: visibleIndex == 0,
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
    );
  }
}
