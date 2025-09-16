import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:banking_app/features/transfer/states/transfer_event.dart';
import 'package:banking_app/features/transfer/states/transfer_state.dart';
import 'package:banking_app/features/transfer/models/transfer_model.dart';
import 'package:banking_app/features/transfer/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionTypeSelection extends StatelessWidget {
  final TransferState state;

  const TransactionTypeSelection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final transactionTypes = [
      TransactionTypeItem(
        title: S.current.transferViaCardNumberTitle,
        icon: Icons.credit_card_rounded,
        type: TransferType.cardNumber,
      ),
      TransactionTypeItem(
        title: S.current.transferSameBankTitle,
        icon: Icons.account_balance_rounded,
        type: TransferType.sameBank,
      ),
      TransactionTypeItem(
        title: S.current.transferAnotherBankTitle,
        icon: Icons.account_balance_wallet_rounded,
        type: TransferType.otherBank,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.transferChooseTransactionTitle,
          style: context.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colorScheme.inverseSurface,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            itemCount: transactionTypes.length,
            itemBuilder: (context, index) {
              final item = transactionTypes[index];
              final isSelected = state.selectedTransferType == item.type;

              return Padding(
                padding: EdgeInsets.only(
                  right: index < transactionTypes.length - 1 ? 12 : 0,
                ),
                child: TransactionCard(
                  isSelected: isSelected,
                  onTap: () {
                    context.read<TransferBloc>().add(
                      SelectTransferTypeEvt(item.type),
                    );
                    HapticFeedback.lightImpact();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        item.icon,
                        color: context.colorScheme.onPrimary,
                        size: 28,
                      ),
                      const SizedBox(height: 11),
                      Text(
                        item.title,
                        style: context.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TransactionTypeItem {
  final String title;
  final IconData icon;
  final TransferType type;

  TransactionTypeItem({
    required this.title,
    required this.icon,
    required this.type,
  });
}
