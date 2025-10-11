import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/bill_payment/models/bill_payment_model.dart';
import 'package:banking_app/features/bill_payment/models/company_model.dart';
import 'package:banking_app/features/bill_payment/blocs/bill_payment_event.dart';
import 'package:banking_app/features/bill_payment/blocs/bill_payment_state.dart';
import 'package:banking_app/features/bill_payment/views/bill_payment_detail_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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
    description: 'BillPaymentDetailsScreen Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'UI Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'shows title and OTP section',
            buildWidget: () => createBillPayTestWidgetWithBloc(
              mockBloc: mockBloc,
              child: BillPaymentDetailsScreen(
                bill: BillPaymentModel(
                  id: 'b',
                  billType: BillType.electric,
                  billCode: 'ABC',
                  company: const CompanyModel(
                    id: 'c1',
                    name: 'Electric Co',
                    code: 'ELEC',
                  ),
                  userId: 'user123',
                  address: '123 Main St',
                  phoneNumber: '0123456789',
                  amount: 100.0,
                  tax: 10.0,
                  startDate: DateTime.now().subtract(const Duration(days: 30)),
                  endDate: DateTime.now(),
                ),
              ),
              initialState: const BillPaymentState(
                status: BillPaymentStatus.loaded(),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(
                    find.text(BillType.electric.displayName),
                    findsOneWidget,
                  );
                  expect(
                    find.text(S.current.transferGetOtpTransactionTitle),
                    findsOneWidget,
                  );
                  expect(
                    find.text(S.current.transferGetOtpButton),
                    findsWidgets,
                  );
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'pay requires OTP then triggers PayBillEvt',
            buildWidget: () => createBillPayTestWidgetWithBloc(
              mockBloc: mockBloc,
              child: BillPaymentDetailsScreen(
                bill: const BillPaymentModel(
                  id: 'b',
                  billType: BillType.electric,
                  billCode: 'ABC',
                ),
              ),
              initialState: const BillPaymentState(
                status: BillPaymentStatus.loaded(),
              ),
            ),
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  final otpField = find.bySemanticsLabel(
                    S.current.transferOtpLabel,
                  );
                  await tester.enterText(otpField, '123456');
                  await tester.pumpAndSettle();
                  await tester.ensureVisible(
                    find.text(S.current.payBillButton),
                  );
                  await tester.pumpAndSettle();

                  await tester.tap(find.text(S.current.payBillButton));
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  verify(
                    () => mockBloc.add(any(that: isA<PayBillEvt>())),
                  ).called(1);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ).test();
}
