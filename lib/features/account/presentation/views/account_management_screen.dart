import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/account/presentation/widgets/account_card.dart';
import 'package:banking_app/features/home/data/models/account_model.dart';
import 'package:flutter/material.dart';

/// A screen that displays the details of a bank account in management mode.
class AccountManagementScreen extends StatelessWidget {
  const AccountManagementScreen({super.key, required this.account});

  final AccountModel account;

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      appBar: BAAppBar(
        title: S.current.accountManagementTitle,
        titleColor: context.colorScheme.scrim,
        alignment: BAAppBarAlignment.left,
        iconColor: context.colorScheme.scrim,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        child: AccountCard(account: account, mode: AccountCardMode.management),
      ),
    );
  }
}
