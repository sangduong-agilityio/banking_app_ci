import 'package:banking_app/app/router/app_router.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/card.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/transfer/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key, this.contacts});

  final List<ContactModel>? contacts;

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      appBar: BAAppBar(
        title: S.current.transferMoneyTitle,
        titleColor: context.colorScheme.scrim,
        iconColor: context.colorScheme.scrim,
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: contacts?.length,
                itemBuilder: (context, index) {
                  final contact = contacts?[index];
                  return TransactionCard(
                    title: contact?.name ?? "Jane Cooper",
                    onTap: () => context.pushNamed(
                      BAPaths.transferAmout.name,
                      extra: contact,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
