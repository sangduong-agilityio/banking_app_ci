import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
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
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        CardAction(
          icon: BAAssets.wallet(),
          title: S.current.homeAccountAndCardTitle,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountDetailsScreen()),
            );
          },
        ),
        CardAction(
          icon: BAAssets.syncDevices(),
          title: S.current.homeTransferTitle,
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
          title: S.current.homeWithdrawTitle,
          onTap: () {
            BASnackBar.showNotSupported(context, S.current.pageNotSupportedYet);
          },
        ),
        CardAction(
          icon: BAAssets.mobileBanking(),
          title: S.current.homeMobileRechargeTitle,
          onTap: () {
            BASnackBar.showNotSupported(context, S.current.pageNotSupportedYet);
          },
        ),
        CardAction(
          icon: BAAssets.receipt(),
          title: S.current.homePayTheBillTitle,
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
          icon: BAAssets.saveOnline(),
          title: S.current.homeSaveOnlineTitle,
          onTap: () {
            BASnackBar.showNotSupported(context, S.current.pageNotSupportedYet);
          },
        ),
        CardAction(
          icon: BAAssets.creditCard(),
          title: S.current.homeCreditCardTitle,
          onTap: () {
            BASnackBar.showNotSupported(context, S.current.pageNotSupportedYet);
          },
        ),
        CardAction(
          icon: BAAssets.fileParagraph(),
          title: S.current.homeTransactionReportTitle,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionHistoryScreen(),
              ),
            );
          },
        ),
        CardAction(
          icon: BAAssets.beneficiary(),
          title: S.current.homeBeneficiaryTitle,
          onTap: () {
            BASnackBar.showNotSupported(context, S.current.pageNotSupportedYet);
          },
        ),
      ],
    );
  }
}
