import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/formatters.dart';
import 'package:banking_app/features/home/models/account_model.dart';
import 'package:flutter/material.dart';

enum AccountCardMode { overview, management }

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.account,
    this.mode = AccountCardMode.overview,
  });

  final AccountModel account;
  final AccountCardMode mode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  mode == AccountCardMode.overview
                      ? account.accountType
                      : S.current.accountTitle,
                  style: context.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.scrim,
                  ),
                ),
                Text(
                  account.accountNumber,
                  style: context.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.scrim,
                  ),
                ),
              ],
            ),

            if (mode == AccountCardMode.overview) ...[
              // Overview (Account & Card screen)
              _cardInformation(
                context,
                label: S.current.accountAvailableBalanceTitle,
                value:
                    '\$${FormatterUtils.formatAmount(account.availableBalance)}',
              ),
              _cardInformation(
                context,
                label: S.current.accountBranchTitle,
                value: account.branch,
              ),
            ] else ...[
              // Management (Account Management screen)
              _cardInformation(
                context,
                label: S.current.accountFromDateTitle,
                value: FormatterUtils.formatDate(account.fromDate!),
              ),
              _cardInformation(
                context,
                label: S.current.accountToDateTitle,
                value: FormatterUtils.formatDate(account.toDate!),
              ),
              _cardInformation(
                context,
                label: S.current.accountTermTitle,
                value: account.term ?? '',
              ),
              _cardInformation(
                context,
                label: S.current.accountInterestRateTitle,
                value: "${account.interestRate}%",
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _cardInformation(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.bodySmall?.copyWith(
              color: context.colorScheme.inverseSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: context.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
