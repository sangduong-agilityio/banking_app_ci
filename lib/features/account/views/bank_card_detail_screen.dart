import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/formatters.dart';
import 'package:banking_app/core/widgets/dialog.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:flutter/material.dart';

/// A screen that displays the details of a bank card.
///
/// This screen shows the cardholder's name, card number, valid dates, and
/// available balance. It also provides an option to delete the card.
class BankCardDetailScreen extends StatelessWidget {
  const BankCardDetailScreen({super.key, required this.card});

  final CardModel card;

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      appBar: BAAppBar(
        title: S.current.accountCardTitle,
        titleColor: context.colorScheme.scrim,
        alignment: BAAppBarAlignment.left,
        iconColor: context.colorScheme.scrim,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Details
            _bankCardInformation(
              context,
              S.current.accountNameTitle,
              card.cardHolderName,
            ),
            _bankCardInformation(
              context,
              S.current.accountCardNumberTitle,
              FormatterUtils.maskCardNumber(card.cardNumber),
            ),
            _bankCardInformation(
              context,
              S.current.accountValidFromTitle,
              card.validFrom ?? '',
            ),
            _bankCardInformation(
              context,
              S.current.accountGoodThruTitle,
              card.goodThru ?? '',
            ),
            _bankCardInformation(
              context,
              S.current.accountAvailableBalanceTitle,
              FormatterUtils.formatBalance(card.availableBalance ?? 0),
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  _showDeleteCard(context);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  S.current.accountDeleteCardTitle,
                  style: context.titleMedium?.copyWith(
                    color: context.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A helper widget to display a label and a value in a row.
  Widget _bankCardInformation(
    BuildContext context,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.colorScheme.onTertiary, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.titleMedium?.copyWith(
              color: context.colorScheme.inverseSurface,
            ),
          ),
          Text(
            value,
            style: context.titleMedium?.copyWith(
              color: context.colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog to confirm the deletion of the card.
  void _showDeleteCard(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return BADialog(
          title: S.current.accountDeleteCardTitle,
          content: S.current.accountContentTitle,
          confirmButton: S.current.accountDeleteTitle,
          confirmCancel: S.current.accountCancelTitle,
          onAccept: () async {
            Navigator.pop(context);
          },
          onCancel: () => Navigator.of(ctx).pop(),
        );
      },
    );
  }
}
