import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/search/presentation/blocs/search_state.dart';
import 'package:banking_app/features/search/presentation/widgets/currency_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/utils.dart';
import '../helpers/search_widget_builder.dart';

void main() {
  BAWidgetTest(
    description: 'CurrencyCard & ExchangeBox Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'CurrencyCard UI',
        scenarios: [
          BAWidgetTestScenario(
            description: 'renders label, textfield and suffix currency button',
            buildWidget: () => createSearchTestWidget(
              child: CurrencyCard(
                label: S.current.searchFormTitle,
                currency: 'USD',
                controller: TextEditingController(),
                onCurrencyTap: () {},
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(find.text(S.current.searchFormTitle), findsOneWidget);
                  expect(find.text('USD'), findsOneWidget);
                  expect(find.text(S.current.searchAmoutTitle), findsOneWidget);
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'ExchangeBox UI',
        scenarios: [
          BAWidgetTestScenario(
            description: 'shows exchange rate and button enabled state',
            buildWidget: () => createSearchTestWidget(
              child: ExchangeBox(
                fromCard: CurrencyCard(
                  label: S.current.searchFormTitle,
                  currency: 'USD',
                  controller: TextEditingController(),
                  onCurrencyTap: () {},
                ),
                toCard: CurrencyCard(
                  label: S.current.searchToTitle,
                  currency: 'EUR',
                  controller: TextEditingController(),
                  onCurrencyTap: () {},
                ),
                swapButton: const Icon(Icons.swap_vert),
                exchangeRate: '1 USD = 0.90 EUR',
                isButtonEnabled: true,
                rateStatus: ExchangeRateStatus.fresh,
                lastRateUpdate: DateTime.now(),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(find.text('1 USD = 0.90 EUR'), findsOneWidget);
                  expect(
                    find.text(S.current.searchExchangeButton),
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
