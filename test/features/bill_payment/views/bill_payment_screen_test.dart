import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/bill_payment/states/bill_payment_state.dart';
import 'package:banking_app/features/bill_payment/views/bill_payment_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/utils.dart';
import '../helpers/bill_payment_widget_builder.dart';
import '../mocks/mock_bill_payment_bloc.dart';
import '../helpers/bill_payment_test_setup.dart';

void main() {
  late MockBillPaymentBloc mockBloc;

  setUpAll(() {
    setupBillPaymentFallbacks();
  });

  setUp(() {
    mockBloc = MockBillPaymentBloc();
  });

  tearDown(() {
    cleanupBillPaymentServiceLocator();
  });

  BAWidgetTest(
    description: 'BillPaymentScreen Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'UI Components Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display title and bill type cards',
            buildWidget: () => createBillPayTestWidgetWithBloc(
              mockBloc: mockBloc,
              child: const BillPaymentScreen(),
              initialState: const BillPaymentState(
                status: BillPaymentStatus.initial(),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(find.text(S.current.payBillTitle), findsOneWidget);
                  expect(
                    find.text(S.current.payBillElectricTitle),
                    findsOneWidget,
                  );
                  expect(
                    find.text(S.current.payBillWaterTitle),
                    findsOneWidget,
                  );
                  expect(
                    find.text(S.current.payBillInternetTitle),
                    findsOneWidget,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Navigation/Init',
        scenarios: [
          BAWidgetTestScenario(
            description:
                'tapping electric card triggers initialize on option screen',
            buildWidget: () => createBillPayTestWidgetWithBloc(
              mockBloc: mockBloc,
              child: const BillPaymentScreen(),
            ),
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  await tester.tap(find.text(S.current.payBillElectricTitle));
                  await tester.pump(const Duration(milliseconds: 200));
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  verify(() => mockBloc.add(any())).called(greaterThan(0));
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ).test();
}
