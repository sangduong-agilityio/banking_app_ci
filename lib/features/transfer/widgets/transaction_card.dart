import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/features/transactions/models/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final Widget child;
  final bool isSelected;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final TransferType type;

  const TransactionCard({
    super.key,
    required this.child,
    this.isSelected = false,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 15,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: padding,
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (!isSelected) return context.colorScheme.onTertiary;
    switch (type) {
      case TransferType.cardNumber:
        return context.colorScheme.secondary;
      case TransferType.sameBank:
        return context.colorScheme.tertiary;
      case TransferType.otherBank:
        return context.colorScheme.inversePrimary;
      case TransferType.billPayment:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
