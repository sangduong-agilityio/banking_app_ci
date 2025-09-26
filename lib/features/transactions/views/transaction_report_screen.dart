import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/transactions/models/balance_summary_model.dart';
import 'package:banking_app/features/transactions/models/transaction_model.dart';
import 'package:banking_app/features/transactions/models/transaction_report_model.dart';
import 'package:banking_app/features/transactions/widgets/chart.dart';
import 'package:banking_app/features/transactions/widgets/header.dart';
import 'package:banking_app/features/transactions/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:banking_app/features/home/widgets/card.dart';
import 'package:banking_app/features/transactions/states/transaction_bloc.dart';
import 'package:banking_app/features/transactions/states/transaction_event.dart';
import 'package:banking_app/features/transactions/states/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          body: CustomScrollView(
            slivers: [
              /// Sliver App Bar
              SliverAppBar(
                expandedHeight: 10,
                pinned: true,
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
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: context.colorScheme.onPrimary,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

              /// Sliver Persistent Header for Card
              SliverPersistentHeader(
                pinned: false,
                floating: false,
                delegate: CardPersistentHeaderDelegate(
                  minHeight: 120,
                  maxHeight: 220,
                ),
              ),

              /// Sliver To Box Adapter for the rest of the content
              SliverToBoxAdapter(
                child: Container(
                  transform: Matrix4.translationValues(0, -100, 0),
                  decoration: BoxDecoration(
                    color: context.colorScheme.onPrimary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child:
                      BlocConsumer<
                        TransactionReportBloc,
                        TransactionReportState
                      >(
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
                            orElse: () => context.loaderOverlay.hide(),
                          );
                        },
                        builder: (context, state) {
                          final report = state.transactionReport;
                          if (report == null) {
                            return const Center(child: Text("No data"));
                          }
                          return Column(
                            children: [
                              const SizedBox(height: 120),

                              /// Balance chart
                              BalanceHistoryChart(
                                balanceSummary: report.balanceHistory,
                              ),

                              // Transactions
                              TransactionHistory(report: report),
                            ],
                          );
                        },
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card Persistent Header Delegate
class CardPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;

  CardPersistentHeaderDelegate({
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
    final cardHeight = maxHeight * (1 - progress * 0.3);

    return Container(
      height: maxHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 10,
            bottom: 5,
            child: Transform.scale(
              scale: 1 - (progress * 0.3),
              child: SizedBox(
                height: cardHeight,
                child: const CreditCardsSwiper(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class CreditCardsSwiper extends StatelessWidget {
  const CreditCardsSwiper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionReportBloc, TransactionReportState>(
      builder: (context, state) {
        return CardsSwiperWidget<CardModel>(
          cardData: state.cards,
          onCardChange: (index) {
            context.read<TransactionReportBloc>().add(
              ChangeCardIndexEvt(index),
            );
          },
          shouldStartCardCollectionAnimation: state.shouldPlayAnimation,
          onCardCollectionAnimationComplete: (value) {
            context.read<TransactionReportBloc>().add(
              SetAnimationStatusEvt(value),
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
    );
  }
}

class TransactionHistory extends StatelessWidget {
  final TransactionReportModel report;

  const TransactionHistory({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Today Transaction History
          if (report.todayTransactions.isNotEmpty) ...[
            SectionHeader(title: S.current.transactionTodayTitle),
            ...report.todayTransactions.map(
              (transaction) => TransactionItem(
                icon: transaction.category?.iconWidget,
                iconColor: transaction.category?.color,
                title: transaction.type.name,
                subtitle: transaction.status.name,
                amount:
                    '${transaction.amount > 0 ? '+' : ''}\$${transaction.amount.abs()}',
                amountColor: transaction.amount < 0
                    ? context.colorScheme.error
                    : context.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Yesterday Transaction History
          if (report.yesterdayTransactions.isNotEmpty) ...[
            SectionHeader(title: S.current.transactionYesterdayTitle),
            ...report.yesterdayTransactions.map(
              (transaction) => TransactionItem(
                icon: transaction.category?.iconWidget,
                iconColor: transaction.category?.color,
                title: transaction.type.name,
                subtitle: transaction.status.name,
                amount:
                    '${transaction.amount > 0 ? '+' : ''}\$${transaction.amount.abs()}',
                amountColor: transaction.amount < 0
                    ? context.colorScheme.error
                    : context.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Recent Transaction History
          if (report.recentTransactions.isNotEmpty) ...[
            SectionHeader(title: S.current.transactionRecentTitle),
            ...report.recentTransactions.map(
              (transaction) => TransactionItem(
                icon: transaction.category?.iconWidget,
                iconColor: transaction.category?.color,
                title: transaction.type.name,
                subtitle: transaction.status.name,
                amount:
                    '${transaction.amount > 0 ? '+' : ''}\$${transaction.amount.abs()}',
                amountColor: transaction.amount < 0
                    ? context.colorScheme.error
                    : context.colorScheme.secondary,
              ),
            ),
          ],

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

/// Balance History Chart
class BalanceHistoryChart extends StatelessWidget {
  final List<BalanceSummaryModel> balanceSummary;

  const BalanceHistoryChart({super.key, required this.balanceSummary});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            children: [
              Text(
                balanceSummary.isNotEmpty
                    ? "\$${balanceSummary.last.endingBalance.toStringAsFixed(2)}"
                    : "\$0.00",
                style: context.displayLarge?.copyWith(
                  color: context.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "USD",
                style: context.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(height: 220, child: BABalanceChart(data: balanceSummary)),
        ],
      ),
    );
  }
}
