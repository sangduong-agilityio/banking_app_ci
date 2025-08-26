import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/forms/drop_down.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/bills/models/bill_model.dart';
import 'package:banking_app/features/bills/views/bill_payment_detail_screen.dart';
import 'package:flutter/material.dart';

class PaymentOptionScreen extends StatefulWidget {
  const PaymentOptionScreen({
    super.key,
    required this.billType,
    required this.bills,
  });

  final BillType billType;
  final List<BillModel> bills;

  @override
  State<PaymentOptionScreen> createState() => _PaymentOptionScreenState();
}

class _PaymentOptionScreenState extends State<PaymentOptionScreen> {
  final TextEditingController _billCodeController = TextEditingController();
  String? selectedProvider;

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      appBar: BAAppBar(
        title: S.current.payBillTitle,
        titleColor: context.colorScheme.scrim,
        alignment: BAAppBarAlignment.left,
        iconColor: context.colorScheme.scrim,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BADropdown<String>(
                  items: widget.bills
                      .where((bill) => bill.billType == widget.billType)
                      .map((bill) => bill.providerName)
                      .toSet()
                      .toList(),
                  value: selectedProvider,
                  hint: S.current.payBillChooseCompanyHint,
                  onChanged: (value) {
                    setState(() {
                      selectedProvider = value;
                    });
                  },
                  enabled: true,
                  displayText: (provider) => provider,
                ),

                const SizedBox(height: 16),
                Text(
                  S.current.payBillTypeLabel(
                    widget.billType.displayName.toLowerCase(),
                  ),
                  style: context.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),

                BATextField(
                  controller: _billCodeController,
                  hint: S.current.payBillCodeHint,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                Text(
                  S.current.payBillDescription,
                  style: context.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                BAElevatedButton(
                  padding: EdgeInsets.zero,
                  text: S.current.payBillCheckButton,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BillPaymentDetailsScreen(
                          bill: BillModel(
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
                      ),
                    );
                  },

                  // selectedProvider != null &&
                  //     _billCodeController.text.isNotEmpty
                  // ? () {
                  //     final selectedBill = widget.bills.firstWhere(
                  //       (bill) =>
                  //           bill.billType == widget.billType &&
                  //           bill.providerName == selectedProvider &&
                  //           bill.billCode ==
                  //               _billCodeController.text.trim(),
                  //       orElse: () {
                  //         return widget.bills.firstWhere(
                  //           (bill) =>
                  //               bill.billType == widget.billType &&
                  //               bill.providerName == selectedProvider,
                  //         );
                  //       },
                  //     );
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => BillPaymentDetailsScreen(
                  //           bill: BillModel(
                  //             id: '1',
                  //             userId: 'User1',
                  //             billType: BillType.electric,
                  //             providerName: 'Electric Provider',
                  //             accountNumber: '123456',
                  //             address: '123 Main St',
                  //             phoneNumber: '123-456-7890',
                  //             billCode: 'ELEC123',
                  //             startDate: '01/10/2019',
                  //             endDate: '01/11/2019',
                  //             amount: 50.0,
                  //             tax: 10.0,
                  //             dueDate: DateTime.now(),
                  //             isRecurring: false,
                  //             isFavorite: false,
                  //             createdAt: DateTime.now(),
                  //             updatedAt: DateTime.now(),
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   }
                  // : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
