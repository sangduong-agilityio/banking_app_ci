import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/bills/models/bill_model.dart';
import 'package:flutter/material.dart';

class BillDetailCard extends StatelessWidget {
  const BillDetailCard({super.key, required this.bills});

  final BillModel bills;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.payBillAllTitle,
              style: context.titleMedium?.copyWith(
                color: context.colorScheme.scrim,
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoDetail(S.current.payBillNameTitle, bills.userId),
            _buildInfoDetail(S.current.payBillAddressTitle, bills.address),
            _buildInfoDetail(
              S.current.payBillPhoneNumberTitle,
              bills.phoneNumber,
            ),
            _buildInfoDetail(S.current.payBillCodeTitle, bills.billCode),
            _buildInfoDetail(S.current.payBillFormTitle, bills.startDate),
            _buildInfoDetail(S.current.payBillToTitle, bills.endDate),
            _buildAmount(
              S.current.payBillTypeTitle(bills.billType.displayName),
              "\$${bills.amount.toStringAsFixed(2)}",
              valueColor: context.colorScheme.secondary,
            ),
            Divider(color: Colors.grey.shade300),
            _buildAmount(
              S.current.payBillTaxTitle,
              "\$${bills.tax.toStringAsFixed(2)}",
              valueColor: context.colorScheme.secondary,
            ),
            Divider(color: Colors.grey.shade300),
            _buildAmount(
              S.current.payBillTotalTitle,
              "\$${(bills.amount + bills.tax).toStringAsFixed(2)}",
              isBold: true,
              valueColor: context.colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildInfoDetail(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildAmount(
  String label,
  String value, {
  bool isBold = false,
  Color? valueColor,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isBold ? Colors.black : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    ),
  );
}
