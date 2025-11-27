import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/common/utils/formatters.dart';
import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:banking_app/features/transactions/presentation/widgets/transaction_item.dart';
import 'package:flutter/material.dart';

/// Widget wrapper for TransactionItem with business logic
class TransactionListItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TransactionItem(
        icon: transaction.displayIcon,
        iconColor: transaction.displayColor,
        title: transaction.displayTitle,
        subtitle: transaction.displaySubtitle,
        amount: _formatAmount(transaction.amount),
        amountColor: _getAmountColor(context, transaction.amount),
      ),
    );
  }

  String _formatAmount(double amount) {
    final sign = amount > 0 ? '+' : '-';
    final formatted = FormatterUtils.formatAmount(amount.abs());
    return '$sign\$$formatted';
  }

  Color _getAmountColor(BuildContext context, double amount) {
    return amount < 0
        ? context.colorScheme.error
        : context.colorScheme.secondary;
  }
}
