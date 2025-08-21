import 'package:banking_app/app/router/app_router.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/features/dashboard/widgets/card_action.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListViewActions extends StatelessWidget {
  const ListViewActions({super.key});

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
          ),
          CardAction(
            icon: BAAssets.syncDevices(),
            label: S.current.homeTransferTitle,
            onTap: () => context.pushNamed(BAPaths.transfer.name),
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
          ),
          CardAction(
            icon: BAAssets.creditCard(),
            label: S.current.homeCreditCardTitle,
          ),
          CardAction(
            icon: BAAssets.fileParagraph(),
            label: S.current.homeTransactionReportTitle,
          ),
        ],
      ),
    );
  }
}
