import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/common/utils/formatters.dart';
import 'package:banking_app/core/widgets/dialog.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/features/home/data/models/account_model.dart';
import 'package:banking_app/features/home/data/models/card_model.dart';
import 'package:flutter/material.dart';

/// A widget that allows the user to select either a bank account or a bank card.
class AccountOrCardSelector extends StatefulWidget {
  const AccountOrCardSelector({
    super.key,
    required this.accounts,

    required this.cards,
    this.selectedAccount,
    this.selectedCard,
    required this.onSelected,
  });

  final List<AccountModel> accounts;
  final List<CardModel> cards;
  final AccountModel? selectedAccount;
  final CardModel? selectedCard;
  final void Function(AccountModel? account, CardModel? card) onSelected;

  @override
  State<AccountOrCardSelector> createState() => _AccountOrCardSelectorState();
}

class _AccountOrCardSelectorState extends State<AccountOrCardSelector> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _updateControllerText();
  }

  @override
  void didUpdateWidget(covariant AccountOrCardSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateControllerText();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Updates the text of the controller with the selected account or card number.
  void _updateControllerText() {
    _controller.text = widget.selectedAccount?.accountNumber != null
        ? FormatterUtils.maskCardNumber(widget.selectedAccount!.accountNumber)
        : widget.selectedCard?.cardNumber != null
        ? FormatterUtils.maskCardNumber(widget.selectedCard!.cardNumber)
        : '';
  }

  @override
  Widget build(BuildContext context) {
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
        _buildAvailableBalance(context),
      ],
    );
  }

  /// Builds the widget that displays the available balance of the selected account or card.
  Widget _buildAvailableBalance(BuildContext context) {
    final balance =
        widget.selectedAccount?.availableBalance ??
        widget.selectedCard?.availableBalance;

    if (balance == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 14, top: 4),
      child: Text(
        S.current.transferAvailableBalanceTitle(
          FormatterUtils.formatBalance(balance),
        ),
        style: context.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: context.colorScheme.secondary,
        ),
      ),
    );
  }

  void _showSelectorDialog(BuildContext context) {
    final activeAccounts = widget.accounts
        .where((a) => a.status == AccountStatus.active)
        .toList();
    final activeCards = widget.cards
        .where((c) => c.status == CardStatus.active)
        .toList();

    showDialog(
      context: context,
      builder: (dialogContext) => BASelectorDialog<dynamic>(
        title: S.current.transferAccountSelected,
        items: [...activeAccounts, ...activeCards],
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

  /// Returns the value of the selected item for the selector dialog.
  String? _getSelectedValue() {
    if (widget.selectedAccount != null) {
      return 'account_${widget.selectedAccount!.accountNumber}';
    } else if (widget.selectedCard != null) {
      return 'card_${widget.selectedCard!.cardNumber}';
    }
    return null;
  }

  /// Returns the value of an item for the selector dialog.
  String _getItemValue(dynamic item) {
    return switch (item) {
      AccountModel() => 'account_${item.accountNumber}',
      CardModel() => 'card_${item.cardNumber}',
      _ => '',
    };
  }

  String _getItemLabel(dynamic item) {
    return switch (item) {
      AccountModel() =>
        "${item.accountType} - ${FormatterUtils.maskCardNumber(item.accountNumber)} (${item.status?.name ?? ''})",
      CardModel() =>
        "${item.cardType?.displayName ?? ''} - ${FormatterUtils.maskCardNumber(item.cardNumber)} (${item.status?.name ?? ''})",
      _ => '',
    };
  }
}
