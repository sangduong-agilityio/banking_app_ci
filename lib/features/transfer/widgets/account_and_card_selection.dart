import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/formatters.dart';
import 'package:banking_app/core/widgets/dialog.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/features/home/models/account_model.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:banking_app/features/transfer/states/transfer_event.dart';
import 'package:banking_app/features/transfer/states/transfer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountOrCardSelection extends StatefulWidget {
  final List<AccountModel> accounts;
  final List<CardModel> cards;

  const AccountOrCardSelection({
    super.key,
    required this.accounts,
    required this.cards,
  });

  @override
  State<AccountOrCardSelection> createState() => _AccountOrCardSelectionState();
}

class _AccountOrCardSelectionState extends State<AccountOrCardSelection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransferBloc, TransferState>(
      buildWhen: (prev, curr) =>
          prev.selectedAccount != curr.selectedAccount ||
          prev.selectedCard != curr.selectedCard,
      builder: (context, state) {
        final account = state.selectedAccount;
        final card = state.selectedCard;

        _controller.text = account?.accountNumber ?? card?.cardNumber ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _showSelectorDialog(context, state),
              child: IgnorePointer(
                child: BATextField(
                  controller: _controller,
                  hint: S.current.transferSelectedAccountHint,
                  suffixIcon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            if (account != null)
              Padding(
                padding: const EdgeInsets.only(left: 14, top: 4),
                child: Text(
                  S.current.transferAvailableBalanceTitle(
                    "\$${FormatterUtils.formatAmount(account.availableBalance)}",
                  ),
                  style: context.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.secondary,
                  ),
                ),
              )
            else if (card != null)
              Padding(
                padding: const EdgeInsets.only(left: 14, top: 4),
                child: Text(
                  S.current.transferAvailableBalanceTitle(
                    "\$${FormatterUtils.formatAmount(card.availableBalance ?? 0)}",
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

  void _showSelectorDialog(BuildContext context, TransferState state) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<TransferBloc>(),
        child: BASelectorDialog<dynamic>(
          title: S.current.transferAccountSelected,
          items: [...widget.accounts, ...widget.cards],
          selectedValue: _getSelectedValue(state),
          value: (item) => _getItemValue(item),
          label: (item) => _getItemLabel(item),
          onSelected: (item) {
            if (item is AccountModel) {
              context.read<TransferBloc>().add(SelectAccountEvt(item));
            } else if (item is CardModel) {
              context.read<TransferBloc>().add(SelectCardEvt(item));
            }
            Navigator.of(dialogContext).pop();
          },
        ),
      ),
    );
  }

  String? _getSelectedValue(TransferState state) {
    if (state.selectedAccount != null) {
      final value = 'account_${state.selectedAccount?.accountNumber}';
      return value;
    } else if (state.selectedCard != null) {
      final value = 'card_${state.selectedCard?.cardNumber}';
      return value;
    }
    return null;
  }

  String _getItemValue(dynamic item) {
    if (item is AccountModel) {
      return 'account_${item.accountNumber}';
    } else if (item is CardModel) {
      return 'card_${item.cardNumber}';
    }
    return '';
  }

  String _getItemLabel(dynamic item) {
    if (item is AccountModel) {
      return "${item.accountType} - ${item.accountNumber}";
    } else if (item is CardModel) {
      return "${item.cardType?.displayName ?? ''} - ${item.cardNumber}";
    }
    return '';
  }
}
