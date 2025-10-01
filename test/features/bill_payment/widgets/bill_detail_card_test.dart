import 'dart:ui';

import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/bill_payment/models/bill_payment_model.dart';
import 'package:banking_app/features/bill_payment/widgets/bill_detail_card.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/utils.dart';
import '../helpers/bill_payment_widget_builder.dart';

void main() {
  BAWidgetTest(
    description: 'BillDetailCard Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'UI Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'renders labels and amounts correctly',
            setUp: (tester) async {
              tester.view.physicalSize = const Size(1080, 1920);
              tester.view.devicePixelRatio = 1.0;
            },
            tearDown: (tester) async {
              tester.view.reset();
            },
            buildWidget: () => createBillPayTestWidget(
              child: BillDetailCard(
                bills: const BillPaymentModel(
                  userId: 'John Doe',
                  address: '123 Main St',
                  phoneNumber: '0123456789',
                  billCode: 'ABC-001',
                  amount: 120.5,
                  tax: 5.0,
                ),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(find.text(S.current.payBillAllTitle), findsOneWidget);
                  expect(find.text(S.current.payBillNameTitle), findsOneWidget);
                  expect(find.text('John Doe'), findsOneWidget);
                  expect(
                    find.text(S.current.payBillAddressTitle),
                    findsOneWidget,
                  );
                  expect(find.text('123 Main St'), findsOneWidget);
                  expect(
                    find.text(S.current.payBillPhoneNumberTitle),
                    findsOneWidget,
                  );
                  expect(find.text('0123456789'), findsOneWidget);
                  expect(find.text(S.current.payBillCodeTitle), findsOneWidget);
                  expect(find.text('ABC-001'), findsOneWidget);

                  // Amounts
                  expect(find.textContaining(''), findsNothing);
                  expect(find.textContaining(''), findsNothing);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ).test();
}
