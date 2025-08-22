import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/bills/models/bill_model.dart';
import 'package:banking_app/features/bills/pages/bill_payment_detail_page.dart';
import 'package:banking_app/features/bills/pages/bill_payment_history_page.dart';
import 'package:banking_app/features/bills/widgets/bill_category_card.dart';
import 'package:flutter/material.dart';

class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({super.key, required this.bills});

  final List<BillModel> bills;

  @override
  State<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      appBar: BAAppBar(
        title: S.current.payBillTitle,
        titleColor: context.colorScheme.scrim,
        alignment: BAAppBarAlignment.left,
        iconColor: context.colorScheme.scrim,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BillCategoryCard(
            billCategory: S.current.payBillElectricTitle,
            billCategoryName: S.current.payBillElectricDescription,
            imageUrl: BAAssets.electric(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BillPaymentDetailsScreen(
                    billType: BillType.electric,
                    bills: widget.bills,
                  ),
                ),
              );
            },
          ),
          BillCategoryCard(
            billCategory: S.current.payBillWaterTitle,
            billCategoryName: S.current.payBillWaterDescription,
            imageUrl: BAAssets.water(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BillPaymentDetailsScreen(
                    billType: BillType.water,
                    bills: widget.bills,
                  ),
                ),
              );
            },
          ),
          BillCategoryCard(
            billCategory: S.current.payBillInternetTitle,
            billCategoryName: S.current.payBillInternetDescription,
            imageUrl: BAAssets.internet(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BillPaymentDetailsScreen(
                    billType: BillType.internet,
                    bills: widget.bills,
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentHistoryScreen(
                      bills: [
                        BillModel(
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
                      ],
                    ),
                  ),
                );
              },
              child: Text(
                S.current.payBillCheckHistoryTitle,
                style: context.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
