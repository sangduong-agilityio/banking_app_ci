import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/features/bills/models/bill_model.dart';
import 'package:banking_app/features/bills/views/bill_payment_screen.dart';
import 'package:banking_app/features/home/widgets/card_action.dart';
import 'package:banking_app/features/home/views/account_screen.dart';
import 'package:banking_app/features/transactions/views/transaction_history_screen.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:banking_app/features/transfer/views/transfer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => locator<TransferBloc>(),
                    child: const TransferScreen(),
                  ),
                ),
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
