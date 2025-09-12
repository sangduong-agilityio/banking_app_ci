import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/formatters.dart';
import 'package:banking_app/core/widgets/bottom_sheet.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/features/transfer/bloc/transfer_bloc.dart';
import 'package:banking_app/features/transfer/bloc/transfer_event.dart';
import 'package:banking_app/features/transfer/bloc/transfer_state.dart';
import 'package:banking_app/features/transfer/models/transfer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountSection extends StatelessWidget {
  final List<Account> accounts;

  const AccountSection({super.key, required this.accounts});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TransferBloc, TransferState, Account?>(
      selector: (state) => state.selectedAccount,
      builder: (context, selectedAccount) {
        final maskedNumber = selectedAccount?.maskedNumber ?? "";

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _showAccountSelector(context),
              child: AbsorbPointer(
                child: BATextField(
                  controller: TextEditingController(text: maskedNumber),
                  hint: S.current.transferSelectedAccountHint,
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ),
              ),
            ),
            if (selectedAccount != null)
              Padding(
                padding: const EdgeInsets.only(left: 14, top: 8),
                child: Text(
                  S.current.transferAvailableBalanceTitle(
                    "\$${FormatterUtils.formatAmount(selectedAccount.availableBalance)}",
                  ),
                  style: context.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.secondary,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showAccountSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => BASelectionSheet<Account>(
        title: S.current.transferAccountSelected,
        items: accounts,
        itemBuilder: (ctx, account) => ListTile(
          title: Text(account.maskedNumber),
          subtitle: Text(
            S.current.transferAvailableBalanceTitle(
              "\$${FormatterUtils.formatAmount(account.availableBalance)}",
            ),
            style: context.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.secondary,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: context.colorScheme.scrim,
          ),
        ),
        onItemSelected: (account) {
          context.read<TransferBloc>().add(SelectAccountEvt(account));
        },
      ),
    );
  }
}
