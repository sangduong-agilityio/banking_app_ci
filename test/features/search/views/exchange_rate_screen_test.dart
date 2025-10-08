import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/search/models/exchange_rate_model.dart';
import 'package:banking_app/features/search/states/search_event.dart';
import 'package:banking_app/features/search/states/search_state.dart';
import 'package:banking_app/features/search/views/exchange_rate_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/utils.dart';
import '../helpers/search_test_setup.dart';
import '../helpers/search_widget_builder.dart';
import '../mocks/mock_search_bloc.dart';

void main() {
  late MockSearchBloc mockBloc;

  setUpAll(() {
    setupSearchFallbacks();
  });

  setUp(() {
    mockBloc = MockSearchBloc();
  });
  tearDown(() {
    cleanupSearchServiceLocator();
  });

  BAWidgetTest(
    description: 'ExchangeRateScreen Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'UI States',
        scenarios: [
          BAWidgetTestScenario(
            description: 'shows title and loading indicator',
            buildWidget: () => createSearchTestWidgetWithBloc(
              mockBloc: mockBloc,
              child: const ExchangeRateScreen(),
            ),
            interactions: const [
              BAWaitInteraction(duration: Duration(milliseconds: 200)),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(
                    find.text(S.current.searchExchangeRateTitle),
                    findsOneWidget,
                  );
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'shows headers and rows when success',
            buildWidget: () {
              final state = const SearchState(
                status: SearchStatus.success(),
                exchangeRates: [
                  ExchangeRateModel(
                    country: 'USA',
                    flag: 'https://flag',
                    buy: '1.00',
                    sell: '1.10',
                  ),
                ],
              );
              when(() => mockBloc.state).thenReturn(state);
              when(
                () => mockBloc.stream,
              ).thenAnswer((_) => Stream.value(state));
              return createSearchTestWidgetWithBloc(
                mockBloc: mockBloc,
                child: const ExchangeRateScreen(),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Verify table headers
                  expect(
                    find.text(S.current.searchCountryTitle),
                    findsOneWidget,
                  );
                  expect(find.text(S.current.searchBuyTitle), findsOneWidget);
                  expect(find.text(S.current.searchSellTitle), findsOneWidget);

                  // Verify table data
                  expect(find.text('USA'), findsOneWidget);
                  expect(find.text('1.00'), findsOneWidget);
                  expect(find.text('1.10'), findsOneWidget);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'tap refresh dispatches refresh event',
            buildWidget: () => createSearchTestWidgetWithBloc(
              mockBloc: mockBloc,
              child: const ExchangeRateScreen(),
            ),
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  final refresh = find.byIcon(Icons.refresh);
                  await tester.tap(refresh);
                  await tester.pump(const Duration(milliseconds: 100));
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  verify(
                    () =>
                        mockBloc.add(any(that: isA<ExchangeRateRefreshEvt>())),
                  ).called(greaterThan(0));
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ).test();
}
