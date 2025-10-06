import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/formatters.dart';
import 'package:banking_app/core/widgets/dialog.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:flutter/material.dart';

class BankCardDetailScreen extends StatelessWidget {
  const BankCardDetailScreen({super.key, required this.cards});

  final CardModel cards;

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
              cards.cardHolderName,
            ),
            _bankCardInformation(
              context,
              S.current.accountCardNumberTitle,
              FormatterUtils.maskCardNumber(cards.cardNumber),
            ),
            _bankCardInformation(
              context,
              S.current.accountValidFromTitle,
              cards.validFrom ?? '',
            ),
            _bankCardInformation(
              context,
              S.current.accountGoodThruTitle,
              cards.goodThru ?? '',
            ),
            _bankCardInformation(
              context,
              S.current.accountAvailableBalanceTitle,
              FormatterUtils.formatBalance(cards.availableBalance ?? 0),
            ),

            const Spacer(),
            // Delete Card Button
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
