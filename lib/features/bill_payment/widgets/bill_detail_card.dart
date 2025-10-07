import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/formatters.dart';
import 'package:banking_app/features/bill_payment/models/bill_payment_model.dart';
import 'package:flutter/material.dart';

class BillDetailCard extends StatelessWidget {
  const BillDetailCard({super.key, required this.bills});

  final BillPaymentModel bills;

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
            bills.user?.username ?? '',
          ),
          _buildInfoDetail(S.current.payBillAddressTitle, bills.address ?? ''),
          _buildInfoDetail(
            S.current.payBillPhoneNumberTitle,
            bills.phoneNumber ?? '',
          ),
          _buildInfoDetail(S.current.payBillCodeTitle, bills.billCode ?? ''),
          _buildInfoDetail(
            S.current.payBillFormTitle,
            FormatterUtils.formatDate(bills.startDate),
          ),
          _buildInfoDetail(
            S.current.payBillToTitle,
            FormatterUtils.formatDate(bills.endDate),
          ),

          _buildAmount(
            S.current.payBillTypeTitle(bills.billType?.displayName ?? ''),
            "\$${bills.amount?.toStringAsFixed(2)}",
            valueColor: context.colorScheme.secondary,
          ),
          Divider(color: Colors.grey.shade300),

          if ((bills.tax ?? 0) > 0)
            _buildAmount(
              S.current.payBillTaxTitle,
              "\$${bills.tax?.toStringAsFixed(2)}",
              valueColor: context.colorScheme.secondary,
            ),
          Divider(color: Colors.grey.shade300),

          _buildAmount(
            S.current.payBillTotalTitle,
            "\$${((bills.amount ?? 0) + (bills.tax ?? 0)).toStringAsFixed(2)}",
            isBold: true,
            valueColor: context.colorScheme.error,
          ),
        ],
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
