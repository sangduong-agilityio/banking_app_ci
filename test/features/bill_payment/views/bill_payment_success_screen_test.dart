import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/bill_payment/models/bill_payment_model.dart';
import 'package:banking_app/features/bill_payment/views/bill_payment_success_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/utils.dart';
import '../helpers/bill_payment_widget_builder.dart';

void main() {
  BAWidgetTest(
    description: 'PaymentSuccessScreen Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'UI Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'shows success messages and confirm button',
            buildWidget: () => createBillPayTestWidget(
              child: PaymentSuccessScreen(
                bill: const BillPaymentModel(billType: BillType.electric),
                transactionId: 'transaction',
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(
                    find.text(S.current.payBillTransactionSuccess),
                    findsOneWidget,
                  );
                  expect(
                    find.text(S.current.payBillConfirmButton),
                    findsOneWidget,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ).test();
}
