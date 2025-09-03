import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/transfer/models/contact_model.dart';
import 'package:flutter/material.dart';

class TransferSuccessScreen extends StatelessWidget {
  const TransferSuccessScreen({super.key, this.contact});
  final ContactModel? contact;

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              BAAssets.success(),
              SizedBox(height: 40),
              Text(
                '\$ ${contact?.lastTransactionAmount ?? '320'} has been\nsent to ${contact?.name ?? 'Jane'}!',
                style: context.displaySmall,
                textAlign: TextAlign.center,
              ),
              const Spacer(),

              TextButton(
                onPressed: () {},
                child: Text(
                  S.current.tranfersMoneyViewReceipt,
                  style: context.titleMedium?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
        child: BAElevatedButton(
          height: 56,
          text: S.current.tranfersMoneySendButton,
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
    );
  }
}
