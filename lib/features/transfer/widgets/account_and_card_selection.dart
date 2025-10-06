import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/formatters.dart';
import 'package:banking_app/core/widgets/dialog.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/features/home/models/account_model.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:flutter/material.dart';

class AccountOrCardSelector extends StatefulWidget {
  final List<AccountModel> accounts;
  final List<CardModel> cards;

  final AccountModel? selectedAccount;
  final CardModel? selectedCard;

  final void Function(AccountModel? account, CardModel? card) onSelected;

  const AccountOrCardSelector({
    super.key,
    required this.accounts,
    required this.cards,
    this.selectedAccount,
    this.selectedCard,
    required this.onSelected,
  });

  @override
  State<AccountOrCardSelector> createState() => _AccountOrCardSelectorState();
}

class _AccountOrCardSelectorState extends State<AccountOrCardSelector> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.selectedAccount?.accountNumber != null
          ? FormatterUtils.maskCardNumber(widget.selectedAccount!.accountNumber)
          : widget.selectedCard?.cardNumber != null
          ? FormatterUtils.maskCardNumber(widget.selectedCard!.cardNumber)
          : '',
    );
  }

  @override
  void didUpdateWidget(covariant AccountOrCardSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.text = widget.selectedAccount?.accountNumber != null
        ? FormatterUtils.maskCardNumber(widget.selectedAccount!.accountNumber)
        : widget.selectedCard?.cardNumber != null
        ? FormatterUtils.maskCardNumber(widget.selectedCard!.cardNumber)
        : '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final account = widget.selectedAccount;
    final card = widget.selectedCard;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _showSelectorDialog(context),
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
                FormatterUtils.formatBalance(account.availableBalance),
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
                FormatterUtils.formatBalance(card.availableBalance ?? 0),
              ),
              style: context.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.secondary,
              ),
            ),
          ),
      ],
    );
  }

  void _showSelectorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BASelectorDialog<dynamic>(
        title: S.current.transferAccountSelected,
        items: [...widget.accounts, ...widget.cards],
        selectedValue: _getSelectedValue(),
        value: (item) => _getItemValue(item),
        label: (item) => _getItemLabel(item),
        onSelected: (item) {
          if (item is AccountModel) {
            widget.onSelected(item, null);
          } else if (item is CardModel) {
            widget.onSelected(null, item);
          }
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  String? _getSelectedValue() {
    if (widget.selectedAccount != null) {
      return 'account_${widget.selectedAccount!.accountNumber}';
    } else if (widget.selectedCard != null) {
      return 'card_${widget.selectedCard!.cardNumber}';
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
      return "${item.accountType} - ${FormatterUtils.maskCardNumber(item.accountNumber)}";
    } else if (item is CardModel) {
      return "${item.cardType?.displayName ?? ''} - ${FormatterUtils.maskCardNumber(item.cardNumber)}";
    }
    return '';
  }
}
