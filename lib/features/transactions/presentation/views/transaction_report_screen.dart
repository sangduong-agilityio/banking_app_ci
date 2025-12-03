import 'package:banking_app/core/common/utils/formatters.dart';
import 'package:banking_app/core/widgets/card.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/transactions/data/models/balance_summary_model.dart';
import 'package:banking_app/features/transactions/presentation/widgets/chart.dart';
import 'package:banking_app/features/transactions/presentation/widgets/header.dart';
import 'package:banking_app/features/transactions/presentation/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/home/data/models/card_model.dart';
import 'package:banking_app/core/widgets/cards_swiper.dart';
import 'package:banking_app/features/transactions/presentation/blocs/transaction_bloc.dart';
import 'package:banking_app/features/transactions/presentation/blocs/transaction_event.dart';
import 'package:banking_app/features/transactions/presentation/blocs/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

class TransactionReportScreen extends StatelessWidget {
  const TransactionReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          locator<TransactionReportBloc>()
            ..add(TransactionReportInitializeEvt()),
      child: LoaderOverlay(
        child: BAScaffold(
          backgroundColor: context.colorScheme.secondary,
          body: Stack(
            children: [
              // Background layer - ALWAYS white below fold
              Positioned.fill(
                child: Column(
                  children: [
                    Container(
                      height: 280,
                      color: context.colorScheme.secondary,
                    ),
                    Expanded(
                      child: Container(color: context.colorScheme.onPrimary),
                    ),
                  ],
                ),
              ),

              // Scrollable content on top
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  /// Sliver App Bar
                  SliverAppBar(
                    expandedHeight: 10,
                    pinned: true,
                    titleSpacing: 0,
                    backgroundColor: context.colorScheme.secondary,
                    elevation: 0,
                    title: Text(
                      S.current.transactionReportTitle,
                      style: context.headlineMedium?.copyWith(
                        color: context.colorScheme.onPrimary,
                      ),
                    ),
                    centerTitle: false,
                    leading: IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: context.colorScheme.onPrimary,
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ),

                  /// Sliver Persistent Header for Card
                  SliverPersistentHeader(
                    pinned: false,
                    floating: false,
                    delegate: CardPersistentHeaderDelegate(
                      minHeight: 20,
                      maxHeight: 220,
                    ),
                  ),

                  /// Sliver Content with overlap and BlocConsumer
                  BlocConsumer<TransactionReportBloc, TransactionReportState>(
                    listener: (context, state) {
                      state.status.maybeWhen(
                        loading: () => context.loaderOverlay.show(),
                        success: () {
                          if (context.mounted) context.loaderOverlay.hide();
                        },
                        failure: () {
                          context.loaderOverlay.hide();
                          BASnackBar.buildErrorSnackbar(
                            context,
                            state.errorMessage ?? '',
                          );
                        },
                        orElse: () {},
                      );
                    },
                    builder: (context, state) {
                      final report = state.transactionReport;

                      return SliverToBoxAdapter(
                        child: Transform.translate(
                          offset: const Offset(0, -100),
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.colorScheme.onPrimary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            padding: const EdgeInsets.only(
                              top: 120,
                              bottom: 100,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /// Balance Chart Section
                                if (report == null)
                                  Container(
                                    height: 200,
                                    margin: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: context
                                          .colorScheme
                                          .surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  )
                                else
                                  BalanceHistoryChart(
                                    balanceSummary: report.balanceHistory,
                                  ),

                                /// Transaction History Section
                                if (report != null) ...[
                                  if (report.todayTransactions.isNotEmpty) ...[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        24,
                                        24,
                                        24,
                                        0,
                                      ),
                                      child: SectionHeader(
                                        title: S.current.transactionTodayTitle,
                                      ),
                                    ),
                                    ...report.todayTransactions.map(
                                      (transaction) => TransactionListItem(
                                        transaction: transaction,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                  if (report
                                      .yesterdayTransactions
                                      .isNotEmpty) ...[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        24,
                                        0,
                                        24,
                                        0,
                                      ),
                                      child: SectionHeader(
                                        title:
                                            S.current.transactionYesterdayTitle,
                                      ),
                                    ),
                                    ...report.yesterdayTransactions.map(
                                      (transaction) => TransactionListItem(
                                        transaction: transaction,
                                      ),
                                    ),
                                  ],
                                ],
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
      
      ),
    ),
  );

  }
}

class CardPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;

  const CardPersistentHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = shrinkOffset / maxExtent;
    final currentHeight = (maxHeight - shrinkOffset).clamp(
      minHeight,
      maxHeight,
    );

    return RepaintBoundary(
      child: SizedBox(
        height: currentHeight,
        child: ClipRect(
          child: OverflowBox(
            maxHeight: maxHeight,
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: maxHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Transform.scale(
                  scale: (1 - progress * 0.3).clamp(0.7, 1.0),
                  alignment: Alignment.topCenter,
                  child: Opacity(
                    opacity: (1 - progress * 1.2).clamp(0.0, 1.0),
                    child: const CreditCardsSwiper(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(CardPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight;
  }
}

class CreditCardsSwiper extends StatelessWidget {
  const CreditCardsSwiper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      TransactionReportBloc,
      TransactionReportState,
      (List<CardModel>, bool)
    >(
      selector: (state) => (state.cards, state.shouldPlayAnimation),
      builder: (context, data) {
        final (cards, shouldPlayAnimation) = data;

        return CardsSwiperWidget<CardModel>(
          cardData: cards,
          onCardChange: (index) {
            context.read<TransactionReportBloc>().add(
              ChangeCardIndexEvt(index),
            );
          },
          shouldStartCardCollectionAnimation: shouldPlayAnimation,
          onCardCollectionAnimationComplete: (value) {
            context.read<TransactionReportBloc>().add(
              SetAnimationStatusEvt(value),
            );
          },
          cardBuilder: (context, index, visibleIndex) {
            final card = cards[index];
            return SwipeableCreditCard(
              key: ValueKey<int>(index),
              data: card,
              isActive: visibleIndex == 0,
            );
          },
        );
      },
    );
  }
}

/// Balance History Chart
class BalanceHistoryChart extends StatelessWidget {
  final List<BalanceSummaryModel> balanceSummary;

  const BalanceHistoryChart({super.key, required this.balanceSummary});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.current.transactionBalanceTitle,
              style: context.bodySmall?.copyWith(
                color: context.colorScheme.scrim,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  balanceSummary.isNotEmpty
                      ? FormatterUtils.formatAmount(
                          balanceSummary.last.endingBalance,
                        )
                      : '0.00',
                  style: context.displayLarge?.copyWith(
                    color: context.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  height: 22,
                  child: Text(
                    'USD',
                    style: context.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(height: 220, child: BABalanceChart(data: balanceSummary)),
          ],
        ),
      ),
    );
  }
}
