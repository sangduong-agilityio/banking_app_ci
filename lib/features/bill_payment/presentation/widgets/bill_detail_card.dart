import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/common/utils/formatters.dart';
import 'package:banking_app/features/bill_payment/data/models/bill_payment_model.dart';
import 'package:flutter/material.dart';

/// A card widget that displays the detailed information of a bill.
class BillDetailCard extends StatelessWidget {
  const BillDetailCard({super.key, required this.bill});

  final BillPaymentModel bill;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
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

          _buildInfoDetail(
            S.current.payBillNameTitle,
            bill.user?.username ?? '',
          ),
          _buildInfoDetail(S.current.payBillAddressTitle, bill.address ?? ''),
          _buildInfoDetail(
            S.current.payBillPhoneNumberTitle,
            bill.phoneNumber ?? '',
          ),
          _buildInfoDetail(S.current.payBillCodeTitle, bill.billCode ?? ''),
          _buildInfoDetail(
            S.current.payBillFormTitle,
            FormatterUtils.formatDate(bill.startDate),
          ),
          _buildInfoDetail(
            S.current.payBillToTitle,
            FormatterUtils.formatDate(bill.endDate),
          ),

          _buildAmount(
            S.current.payBillTypeTitle(bill.billType?.displayName ?? ''),
            "\$${bill.amount?.toStringAsFixed(2)}",
            valueColor: context.colorScheme.secondary,
          ),
          Divider(color: Colors.grey.shade300),

          if ((bill.tax ?? 0) > 0)
            _buildAmount(
              S.current.payBillTaxTitle,
              "\$${bill.tax?.toStringAsFixed(2)}",
              valueColor: context.colorScheme.secondary,
            ),
          Divider(color: Colors.grey.shade300),

          _buildAmount(
            S.current.payBillTotalTitle,
            "\$${((bill.amount ?? 0) + (bill.tax ?? 0)).toStringAsFixed(2)}",
            isBold: true,
            valueColor: context.colorScheme.error,
          ),
        ],
      ),
    );
  }
}

/// A helper widget to build a row with a label and a value for displaying bill details.
Widget _buildInfoDetail(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    ),
  );
}

/// A helper widget to build a row for displaying amounts (e.g., bill amount, tax, total).
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
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isBold ? Colors.black : Colors.grey[600],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
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
