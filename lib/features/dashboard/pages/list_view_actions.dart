import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/features/bills/models/bill_model.dart';
import 'package:banking_app/features/bills/pages/bill_payment_page.dart';
import 'package:banking_app/features/dashboard/widgets/card_action.dart';
import 'package:banking_app/features/profile/pages/account_page.dart';
import 'package:banking_app/features/transactions/pages/transaction_history_page.dart';
import 'package:banking_app/features/transfer/pages/transfer_page.dart';
import 'package:flutter/material.dart';

class ListViewActions extends StatelessWidget {
  const ListViewActions({super.key, this.bills});

  final List<BillModel>? bills;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          CardAction(
            icon: BAAssets.wallet(),
            label: S.current.homeAccountAndCardTitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountDetailsScreen()),
              );
            },
          ),
          CardAction(
            icon: BAAssets.syncDevices(),
            label: S.current.homeTransferTitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TransferScreen()),
              );
            },
          ),
          CardAction(
            icon: BAAssets.creditCardIn(),
            label: S.current.homeWithdrawTitle,
          ),
          CardAction(
            icon: BAAssets.mobileBanking(),
            label: S.current.homeMobileRechargeTitle,
          ),
          CardAction(
            icon: BAAssets.receipt(),
            label: S.current.homePayTheBillTitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BillPaymentScreen(bills: bills ?? []),
                ),
              );
            },
          ),
          CardAction(
            icon: BAAssets.creditCard(),
            label: S.current.homeCreditCardTitle,
          ),
          CardAction(
            icon: BAAssets.fileParagraph(),
            label: S.current.homeTransactionReportTitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
