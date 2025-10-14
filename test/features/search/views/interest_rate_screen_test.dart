import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/search/data/models/interest_rate_model.dart';
import 'package:banking_app/features/search/presentation/blocs/search_event.dart';
import 'package:banking_app/features/search/presentation/blocs/search_state.dart';
import 'package:banking_app/features/search/presentation/views/interest_rate_screen.dart';
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
    description: 'InterestRateScreen Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'Initial State',
        scenarios: [
          BAWidgetTestScenario(
            description: 'dispatches InterestRateInitializeEvt on init',
            buildWidget: () => createSearchTestWidgetWithBloc(
              mockBloc: mockBloc,
              surfaceSize: const Size(800, 1600),
              child: const InterestRateScreen(),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  await tester.pumpAndSettle();
                  verify(
                    () => mockBloc.add(
                      any(that: isA<InterestRateInitializeEvt>()),
                    ),
                  ).called(1);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'displays app bar with title',
            buildWidget: () => createSearchTestWidgetWithBloc(
              mockBloc: mockBloc,
              surfaceSize: const Size(800, 1600),
              child: const InterestRateScreen(),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  await tester.pumpAndSettle();
                  expect(
                    find.text(S.current.searchInterestRateTitle),
                    findsOneWidget,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Success State with Data',
        scenarios: [
          BAWidgetTestScenario(
            description: 'displays table with single interest rate',
            buildWidget: () {
              when(() => mockBloc.state).thenReturn(
                const SearchState(
                  status: SearchStatus.success(),
                  interestRates: [
                    InterestRateModel(
                      type: 'Savings',
                      period: '12m',
                      rate: '5.0%',
                    ),
                  ],
                ),
              );
              return createSearchTestWidgetWithBloc(
                mockBloc: mockBloc,
                surfaceSize: const Size(800, 1600),
                child: const InterestRateScreen(),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  await tester.pumpAndSettle();

                  // Verify data is displayed
                  expect(find.text('Savings'), findsOneWidget);
                  expect(find.text('12m'), findsOneWidget);
                  expect(find.text('5.0%'), findsOneWidget);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'displays table with multiple interest rates',
            buildWidget: () {
              when(() => mockBloc.state).thenReturn(
                const SearchState(
                  status: SearchStatus.success(),
                  interestRates: [
                    InterestRateModel(
                      type: 'Savings',
                      period: '3m',
                      rate: '3.5%',
                    ),
                    InterestRateModel(
                      type: 'Savings',
                      period: '6m',
                      rate: '4.0%',
                    ),
                    InterestRateModel(
                      type: 'Fixed Deposit',
                      period: '12m',
                      rate: '5.5%',
                    ),
                  ],
                ),
              );
              return createSearchTestWidgetWithBloc(
                mockBloc: mockBloc,
                surfaceSize: const Size(800, 1600),
                child: const InterestRateScreen(),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  await tester.pumpAndSettle();

                  // Verify all data rows
                  expect(find.text('Savings'), findsNWidgets(2));
                  expect(find.text('Fixed Deposit'), findsOneWidget);
                  expect(find.text('3m'), findsOneWidget);
                  expect(find.text('6m'), findsOneWidget);
                  expect(find.text('12m'), findsOneWidget);
                  expect(find.text('3.5%'), findsOneWidget);
                  expect(find.text('4.0%'), findsOneWidget);
                  expect(find.text('5.5%'), findsOneWidget);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'displays table headers correctly',
            buildWidget: () {
              when(() => mockBloc.state).thenReturn(
                const SearchState(
                  status: SearchStatus.success(),
                  interestRates: [
                    InterestRateModel(
                      type: 'Savings',
                      period: '12m',
                      rate: '5.0%',
                    ),
                  ],
                ),
              );
              return createSearchTestWidgetWithBloc(
                mockBloc: mockBloc,
                surfaceSize: const Size(800, 1600),
                child: const InterestRateScreen(),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  await tester.pumpAndSettle();

                  // Verify all column headers
                  expect(
                    find.text(S.current.searchInterestKindTitle),
                    findsOneWidget,
                  );
                  expect(
                    find.text(S.current.searchDepositTitle),
                    findsOneWidget,
                  );
                  expect(find.text(S.current.searchRateTitle), findsOneWidget);
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Success State with Empty Data',
        scenarios: [
          BAWidgetTestScenario(
            description: 'shows empty state when no interest rates',
            buildWidget: () {
              when(() => mockBloc.state).thenReturn(
                const SearchState(
                  status: SearchStatus.success(),
                  interestRates: [],
                ),
              );
              return createSearchTestWidgetWithBloc(
                mockBloc: mockBloc,
                surfaceSize: const Size(800, 1600),
                child: const InterestRateScreen(),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  await tester.pumpAndSettle();

                  // Verify screen renders without table
                  expect(find.byType(InterestRateScreen), findsOneWidget);
                  // No data should be displayed
                  expect(find.text('Savings'), findsNothing);
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Table Scrolling',
        scenarios: [
          BAWidgetTestScenario(
            description: 'displays many interest rates',
            buildWidget: () {
              final rates = List.generate(
                10,
                (i) => InterestRateModel(
                  type: 'Type $i',
                  period: '${i + 1}m',
                  rate: '${i + 3}.0%',
                ),
              );

              when(() => mockBloc.state).thenReturn(
                SearchState(
                  status: const SearchStatus.success(),
                  interestRates: rates,
                ),
              );
              return createSearchTestWidgetWithBloc(
                mockBloc: mockBloc,
                surfaceSize: const Size(800, 1600),
                child: const InterestRateScreen(),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  await tester.pumpAndSettle();

                  // Verify first items are visible
                  expect(find.text('Type 0'), findsOneWidget);
                  expect(find.text('Type 1'), findsOneWidget);

                  // Verify data is displayed
                  expect(find.text('1m'), findsOneWidget);
                  expect(find.text('3.0%'), findsOneWidget);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ).test();
}
