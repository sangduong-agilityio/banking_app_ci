import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/bills/models/bill_model.dart';
import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final BillModel bill;

  const PaymentSuccessScreen({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      appBar: BAAppBar(
        title: bill.billType.displayName,
        alignment: BAAppBarAlignment.left,
        titleColor: context.colorScheme.scrim,
        iconColor: context.colorScheme.scrim,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BAAssets.transactionSuccess(),
          SizedBox(height: 30),
          Text(
            S.current.payBillTransactionSuccess,
            style: context.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.secondary,
            ),
          ),
          SizedBox(height: 24),
          Text(
            S.current.payBillTracsactionTitle(bill.billType.displayName),
            style: context.titleSmall?.copyWith(
              color: context.colorScheme.onInverseSurface,
            ),
          ),
          SizedBox(height: 55),
          BAElevatedButton(
            height: 44,
            text: S.current.payBillConfirmButton,
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }
}
