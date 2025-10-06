import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/shimmer.dart';
import 'package:banking_app/features/account/states/account_and_card_cubit.dart';
import 'package:banking_app/features/account/states/account_and_card_state.dart';
import 'package:banking_app/features/account/widgets/account_card.dart';
import 'package:banking_app/features/home/models/account_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      body: BlocBuilder<AccountAndCardCubit, AccountAndCardState>(
        buildWhen: (previous, current) => previous.accounts != current.accounts,
        builder: (context, state) {
          if (state.status is AccountAndCardStatusLoading) {
            return const UserProfileSkeleton();
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 16, bottom: 24),
            itemCount: state.accounts.length,
            itemBuilder: (context, index) {
              final account = state.accounts[index];
              return AccountCard(
                account: account,
                mode: AccountCardMode.management,
              );
            },
          );
        },
      ),
    );
  }
}
