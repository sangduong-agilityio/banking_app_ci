// import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/bills/models/bill_model.dart';
import 'package:banking_app/features/bills/pages/bill_payment_success_page.dart';
import 'package:banking_app/features/bills/widgets/bill_detail_card.dart';
import 'package:flutter/material.dart';

class BillPaymentDetailsScreen extends StatelessWidget {
  const BillPaymentDetailsScreen({
    super.key,
    required this.billType,
    required this.bills,
  });

  final BillType billType;
  final List<BillModel> bills;

  @override
  Widget build(BuildContext context) {
    // final filteredBills = bills
    //     .where((bill) => bill.billType == billType)
    //     .toList();

    return BAScaffold(
      appBar: BAAppBar(
        title: billType.displayName,
        titleColor: context.colorScheme.scrim,
        alignment: BAAppBarAlignment.left,
        iconColor: context.colorScheme.scrim,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            BillDetailCard(
              bills: BillModel(
                id: '1',
                userId: 'User1',
                billType: BillType.electric,
                providerName: 'Electric Provider',
                accountNumber: '123456',
                address: '123 Main St',
                phoneNumber: '123-456-7890',
                billCode: 'ELEC123',
                startDate: '01/10/2019',
                endDate: '01/11/2019',
                amount: 50.0,
                tax: 10.0,
                dueDate: DateTime.now(),
                isRecurring: false,
                isFavorite: false,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            ),
            // Text("01/10/2019 - 01/11/2019", style: context.bodySmall),
            // if (filteredBills.isNotEmpty)
            //   ...filteredBills.map(
            //     (bill) =>
            //         BillDetailCard(bills: bill),
            //   )
            // else
            //   Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Text(
            //       'No bills found for this category.',
            //       style: context.bodyMedium?.copyWith(color: Colors.grey),
            //     ),
            //   ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: context.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text("4411 0000 1234"),
                    ),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: BAElevatedButton(
          height: 44,
          text: S.current.payBillButton,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentSuccessScreen(bills: billType),
              ),
            );
          },
        ),
      ),
    );
  }
}
