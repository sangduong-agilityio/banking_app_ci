import 'package:banking_app/app/router/app_router.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/bill_payment/models/bill_payment_model.dart';
import 'package:banking_app/features/home/widgets/card_action.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListViewActions extends StatelessWidget {
  const ListViewActions({super.key, this.bills});

  final List<BillPaymentModel>? bills;
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        CardAction(
          icon: BAAssets.wallet(),
          title: S.current.homeAccountAndCardTitle,
          onTap: () {
            context.goNamed(BAPaths.account.name);
          },
        ),
        CardAction(
          icon: BAAssets.syncDevices(),
          title: S.current.homeTransferTitle,
          onTap: () {
            context.goNamed(BAPaths.transfer.name);
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
            context.goNamed(BAPaths.payBill.name);
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
            context.goNamed(BAPaths.transactionReport.name);
          },
        ),
        CardAction(
          icon: BAAssets.contacts(),
          title: S.current.homeBeneficiaryTitle,
          onTap: () {
            BASnackBar.showNotSupported(context, S.current.pageNotSupportedYet);
          },
        ),
      ],
    );
  }
}
