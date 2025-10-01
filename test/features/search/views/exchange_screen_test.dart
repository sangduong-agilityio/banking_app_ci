import 'package:banking_app/features/search/states/search_event.dart';
import 'package:banking_app/features/search/views/exchange_screen.dart';
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
    description: 'ExchangeScreen Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'UI Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'shows title and exchange box',
            buildWidget: () => createSearchTestWidgetWithBloc(
              mockBloc: mockBloc,
              child: const ExchangeScreen(),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  BAFindsTextVerification(text: 'Exchange');
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'swap button dispatches swap event',
            buildWidget: () => createSearchTestWidgetWithBloc(
              mockBloc: mockBloc,
              child: const ExchangeScreen(),
            ),
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  final swap = find.byType(GestureDetector).last;
                  await tester.tap(swap);
                  await tester.pump(const Duration(milliseconds: 100));
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  verify(
                    () => mockBloc.add(any(that: isA<SwapCurrenciesEvt>())),
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
