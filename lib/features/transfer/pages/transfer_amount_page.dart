import 'package:banking_app/app/themes/app_colors.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/transfer/models/contact_model.dart';
import 'package:banking_app/features/transfer/pages/transfer_success_page.dart';
import 'package:flutter/material.dart';

class TransferAmountScreen extends StatefulWidget {
  const TransferAmountScreen({super.key, this.contacts});
  final ContactModel? contacts;

  @override
  State<TransferAmountScreen> createState() => _TransferAmountScreenState();
}

class _TransferAmountScreenState extends State<TransferAmountScreen> {
  String selectedAccount = "•••• 2236";
  double balance = 5300.00;

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      appBar: BAAppBar(
        title: S.current.transferMoneyTitle,
        titleColor: context.colorScheme.scrim,
        iconColor: context.colorScheme.scrim,
      ),
      body: Padding(
        padding: EdgeInsets.all(36),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                widget.contacts?.imageUrl ?? 'https://via.placeholder.com/150',
                width: 62,
                height: 62,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.business,
                  color: BAAppColors.textSecondary,
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              widget.contacts?.name ?? 'Jane Cooper',
              style: context.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.scrim,
              ),
            ),
            SizedBox(height: 2),
            Text(
              '3246 •••• •••• 3422',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 30),

            Text(
              widget.contacts?.amount ?? '\$ 320.00',
              style: context.displayLarge,
            ),
            Text('No fee', style: context.bodySmall),
            SizedBox(height: 32),

            // Account Selection
            Text(
              S.current.tranfersMoneySelectAccount,
              style: context.titleSmall?.copyWith(fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 15),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 25,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedAccount,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Balance: \$ ${balance.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(30),
        child: BAElevatedButton(
          height: 56,
          text: S.current.tranfersMoneySendButton,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransferSuccessScreen()),
            );
          },
        ),
      ),
    );
  }
}
