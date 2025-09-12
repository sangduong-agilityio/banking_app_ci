import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/formatters.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/bills/models/bill_model.dart';
import 'package:banking_app/features/bills/models/payment_history_model.dart';
import 'package:banking_app/features/bills/widgets/tab_bar.dart';
import 'package:flutter/material.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final List<BillModel> bills;
  final List<PaymentHistoryModel> paymentHistory;

  const PaymentHistoryScreen({
    super.key,
    required this.bills,
    required this.paymentHistory,
  });

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<BillType> availableTypes;

  @override
  void initState() {
    super.initState();
    availableTypes = widget.bills.map((b) => b.billType).toSet().toList();
    _tabController = TabController(length: availableTypes.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabNames = availableTypes
        .map((type) => _capitalize(type.name))
        .toList();

    return BAScaffold(
      appBar: BAAppBar(
        title: S.current.payBillHistoryTitle,
        titleColor: context.colorScheme.scrim,
        iconColor: context.colorScheme.scrim,
      ),
      body: Column(
        children: [
          BATabBar(controller: _tabController, tabs: tabNames),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: availableTypes
                  .map(
                    (type) => ListViewHistory(
                      billType: type,
                      paymentHistory: _getPaymentHistoryByBillType(type),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  List<PaymentHistoryModel> _getPaymentHistoryByBillType(BillType billType) {
    final billsOfType = widget.bills.where((bill) => bill.billType == billType);

    final billIds = billsOfType.map((bill) => bill.id).toSet();

    final filteredHistory = widget.paymentHistory
        .where((history) => billIds.contains(history.billId))
        .toList();

    filteredHistory.sort((a, b) => b.paymentDate.compareTo(a.paymentDate));

    return filteredHistory;
  }
}

class ListViewHistory extends StatelessWidget {
  const ListViewHistory({
    super.key,
    required this.billType,
    required this.paymentHistory,
  });

  final BillType billType;
  final List<PaymentHistoryModel> paymentHistory;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: paymentHistory.length,
      itemBuilder: (context, index) {
        final history = paymentHistory[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: context.colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFCBD5E0).withAlpha(150),
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    FormatterUtils.formatMonthYear(history.paymentDate),
                    style: context.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    FormatterUtils.formatDate(history.paymentDate),
                    style: context.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.payBillStatusTitle,
                    style: context.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    history.status.displayName,
                    style: context.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: history.status.color,
                    ),
                  ),
                  Text(
                    S.current.payBillAmountTitle,
                    style: context.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "\$${history.amount}",
                    style: context.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    S.current.payBillCompanyTitle,
                    style: context.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    history.providerName,
                    style: context.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
