import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/forms/drop_down.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/bills/models/bill_model.dart';
import 'package:banking_app/features/bills/views/bill_payment_success_screen.dart';
import 'package:banking_app/features/bills/widgets/bill_detail_card.dart';
import 'package:flutter/material.dart';

class BillPaymentDetailsScreen extends StatefulWidget {
  const BillPaymentDetailsScreen({super.key, required this.bill});

  final BillModel bill;

  @override
  State<BillPaymentDetailsScreen> createState() =>
      _BillPaymentDetailsScreenState();
}

class _BillPaymentDetailsScreenState extends State<BillPaymentDetailsScreen> {
  PaymentMethod? selectedPaymentMethod;

  // Sample payment methods
  final List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      id: '1',
      displayName: 'Credit Card',
      cardNumber: '4411 0000 1234',
      type: 'card',
      icon: Icons.credit_card,
    ),
    PaymentMethod(
      id: '2',
      displayName: 'Debit Card',
      cardNumber: '4422 0000 5678',
      type: 'card',
      icon: Icons.credit_card,
    ),
    PaymentMethod(
      id: '3',
      displayName: 'Bank Account',
      cardNumber: '****1234',
      type: 'bank',
      icon: Icons.account_balance,
    ),
    PaymentMethod(
      id: '4',
      displayName: 'Digital Wallet',
      cardNumber: '****9876',
      type: 'wallet',
      icon: Icons.account_balance_wallet,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Set default payment method
    selectedPaymentMethod = paymentMethods.first;
  }

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      appBar: BAAppBar(
        title: widget.bill.billType.displayName,
        titleColor: context.colorScheme.scrim,
        alignment: BAAppBarAlignment.left,
        iconColor: context.colorScheme.scrim,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            BillDetailCard(bills: widget.bill),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: PaymentMethodDropdown(
                paymentMethods: paymentMethods,
                selectedMethod: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: BAElevatedButton(
          padding: EdgeInsets.zero,
          height: 44,
          text: S.current.payBillButton,
          onPressed: selectedPaymentMethod != null
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentSuccessScreen(
                        bill: widget.bill,
                        // paymentMethod: selectedPaymentMethod!,
                      ),
                    ),
                  );
                }
              : null,
        ),
      ),
    );
  }
}
