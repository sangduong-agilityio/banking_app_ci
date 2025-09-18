import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/card.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/transactions/models/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionReportScreen extends StatelessWidget {
  const TransactionReportScreen({super.key, this.transactions});

  final List<TransactionModel>? transactions;
  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: context.colorScheme.onPrimary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.onInverseSurface.withAlpha(30),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(7, 18, 7, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.current.transactionsHistoryTitle,
                        style: context.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: context.colorScheme.scrim,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: transactions?.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions?[index];
                      return TransactionCard(
                        imageUrl:
                            transaction?.imageUrl ??
                            "https://i.pravatar.cc/150?img=3",
                        title: transaction?.recipientName ?? "Jane Cooper",
                        subtitle: transaction?.description ?? "12/12/2023",
                        amount: transaction?.referenceNumber ?? "\$10",
                        isDebit: true,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
