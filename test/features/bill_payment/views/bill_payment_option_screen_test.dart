import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/features/bill_payment/models/bill_payment_model.dart';
import 'package:banking_app/features/bill_payment/models/company_model.dart';
import 'package:banking_app/features/bill_payment/states/bill_payment_state.dart';
import 'package:banking_app/features/bill_payment/views/bill_payment_option_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/utils.dart';
import '../helpers/bill_payment_widget_builder.dart';
import '../mocks/mock_bill_payment_bloc.dart';

void main() {
  late MockBillPaymentBloc mockBloc;

  setUpAll(() {
    setupBillPaymentFallbacks();
  });

  setUp(() {
    mockBloc = MockBillPaymentBloc();
  });

  BAWidgetTest(
    description: 'PaymentOptionScreen Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'UI Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'shows app bar and fields',
            buildWidget: () => createBillPayTestWidgetWithBloc(
              mockBloc: mockBloc,
              child: const PaymentOptionScreen(billType: BillType.electric),
              initialState: BillPaymentState(
                status: const BillPaymentStatus.loaded(),
                bills: [
                  BillPaymentModel(
                    id: 'bill payment',
                    billType: BillType.electric,
                    billCode: 'ABC',
                    company: const CompanyModel(
                      id: 'company',
                      name: 'Electric Co',
                    ),
                  ),
                ],
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(find.text(S.current.payBillTitle), findsOneWidget);
                  expect(
                    find.text(S.current.payBillChooseCompanyHint),
                    findsOneWidget,
                  );
                  expect(find.text(S.current.payBillCodeHint), findsOneWidget);
                  expect(
                    find.text(S.current.payBillCheckButton),
                    findsOneWidget,
                  );
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'select company opens dialog and dispatches event',
            buildWidget: () => createBillPayTestWidgetWithBloc(
              mockBloc: mockBloc,
              child: const PaymentOptionScreen(billType: BillType.electric),
              initialState: BillPaymentState(
                status: const BillPaymentStatus.loaded(),
                bills: [
                  BillPaymentModel(
                    id: 'bill payment',
                    billType: BillType.electric,
                    billCode: 'ABC',
                    company: const CompanyModel(
                      id: 'company',
                      name: 'Electric Co',
                    ),
                  ),
                ],
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final textFields = find.byType(BATextField);
                  tester.widget<BATextField>(textFields.first);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ).test();
}
