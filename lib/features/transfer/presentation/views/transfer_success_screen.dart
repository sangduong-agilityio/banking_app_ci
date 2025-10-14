import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/common/utils/formatters.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:flutter/material.dart';

class TransferSuccessScreen extends StatelessWidget {
  final double amount;
  final String beneficiaryName;

  const TransferSuccessScreen({
    super.key,
    required this.amount,
    required this.beneficiaryName,
  });

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      appBar: BAAppBar(
        title: S.current.transferConfirmTitle,
        titleColor: context.colorScheme.scrim,
        alignment: BAAppBarAlignment.left,
        iconColor: context.colorScheme.scrim,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            BAAssets.transferSuccess(),
            const SizedBox(height: 30),
            Text(
              S.current.payBillTransactionSuccess,
              style: context.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 24),
            SelectionContainer.disabled(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style.copyWith(
                    fontSize: 16,
                    decoration: TextDecoration.none,
                  ),
                  children: [
                    TextSpan(
                      text: S.current.transferSuccessDescription,
                      style: context.titleSmall?.copyWith(
                        color: context.colorScheme.scrim,
                      ),
                    ),
                    TextSpan(
                      text: '\$${FormatterUtils.formatAmount(amount)} ',
                      style: context.titleSmall?.copyWith(
                        color: context.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: S.current.transferToLabel.toLowerCase(),
                      style: context.titleSmall?.copyWith(
                        color: context.colorScheme.scrim,
                      ),
                    ),
                    TextSpan(
                      text: ' $beneficiaryName!',
                      style: context.titleSmall?.copyWith(
                        color: context.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 55),
            BAElevatedButton(
              height: 44,
              text: S.current.payBillConfirmButton,
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}
