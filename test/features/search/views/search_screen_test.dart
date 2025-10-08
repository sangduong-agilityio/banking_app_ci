import 'package:banking_app/app/router/app_router.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/card.dart';
import 'package:banking_app/features/search/views/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/utils.dart';
import '../helpers/search_test_setup.dart';
import '../helpers/search_widget_builder.dart';
import '../mocks/mock_search_bloc.dart';

void main() {
  late MockSearchBloc mockBloc;
  late MockGoRouter mockRouter;

  setUpAll(() {
    setupSearchFallbacks();
  });

  setUp(() {
    mockBloc = MockSearchBloc();
    mockRouter = MockGoRouter();

    // Setup default router behavior
    when(() => mockRouter.canPop()).thenReturn(false);
    when(
      () => mockRouter.goNamed(any(), extra: any(named: 'extra')),
    ).thenAnswer((_) async {});
  });

  tearDown(() {
    cleanupSearchServiceLocator();
  });

  BAWidgetTest(
    description: 'SearchScreen Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'UI Components Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display app bar with title',
            buildWidget: () => createSearchTestWidgetWithBloc(
              mockBloc: mockBloc,
              surfaceSize: const Size(800, 1600), // Increased height
              child: const SearchScreen(),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  await tester.pumpAndSettle();
                  expect(find.text(S.current.searchTitle), findsOneWidget);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display all search category cards',
            buildWidget: () => createSearchTestWidgetWithBloc(
              mockBloc: mockBloc,
              surfaceSize: const Size(800, 1600),
              child: const SearchScreen(),
            ),
            verifications: [
              BAFindsWidgetVerification(
                finder: find.byType(CardCategorySelected),
                count: 4,
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display all category titles',
            buildWidget: () => createSearchTestWidgetWithBloc(
              mockBloc: mockBloc,
              surfaceSize: const Size(800, 1600),
              child: const SearchScreen(),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  await tester.pumpAndSettle();

                  // Verify all titles exist
                  expect(
                    find.text(S.current.searchBranchSelectedTitle),
                    findsOneWidget,
                  );
                  expect(
                    find.text(S.current.searchInterestRateTitle),
                    findsOneWidget,
                  );
                  expect(
                    find.text(S.current.searchExchangeRateTitle),
                    findsOneWidget,
                  );
                  expect(
                    find.text(S.current.searchExchangeTitle),
                    findsOneWidget,
                  );
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display all category descriptions',
            buildWidget: () => createSearchTestWidgetWithBloc(
              mockBloc: mockBloc,
              surfaceSize: const Size(800, 1600),
              child: const SearchScreen(),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  await tester.pumpAndSettle();

                  // Verify all descriptions exist
                  expect(
                    find.text(S.current.searchBranchDescription),
                    findsOneWidget,
                  );
                  expect(
                    find.text(S.current.searchInterestRateDescription),
                    findsOneWidget,
                  );
                  expect(
                    find.text(S.current.searchExchangeRateDescription),
                    findsOneWidget,
                  );
                  expect(
                    find.text(S.current.searchExchangeDescription),
                    findsOneWidget,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Branch Card Interaction',
        scenarios: [
          BAWidgetTestScenario(
            description: 'tap on branch card shows not supported snackbar',
            buildWidget: () => createSearchTestWidgetWithBloc(
              mockBloc: mockBloc,
              child: const SearchScreen(),
            ),
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  await tester.pumpAndSettle();

                  // Find the branch card by its title
                  final branchTitle = find.text(
                    S.current.searchBranchSelectedTitle,
                  );
                  final branchCard = find.ancestor(
                    of: branchTitle,
                    matching: find.byType(CardCategorySelected),
                  );

                  expect(branchCard, findsOneWidget);
                  await tester.tap(branchCard);
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Verify snackbar appears
                  expect(find.byType(SnackBar), findsOneWidget);
                  expect(
                    find.text(S.current.pageNotSupportedYet),
                    findsOneWidget,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Navigation with Router',
        scenarios: [
          BAWidgetTestScenario(
            description:
                'tap on interest rate card navigates to interest rate screen',
            buildWidget: () => _createSearchScreenWithRouter(
              mockBloc: mockBloc,
              mockRouter: mockRouter,
            ),
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  await tester.pumpAndSettle();

                  final interestTitle = find.text(
                    S.current.searchInterestRateTitle,
                  );
                  final interestCard = find.ancestor(
                    of: interestTitle,
                    matching: find.byType(CardCategorySelected),
                  );

                  expect(interestCard, findsOneWidget);
                  await tester.tap(interestCard);
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  verify(
                    () => mockRouter.goNamed(
                      BAPaths.interestRate.name,
                      extra: any(named: 'extra'),
                    ),
                  ).called(1);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description:
                'tap on exchange rate card navigates to exchange rate screen',
            buildWidget: () => _createSearchScreenWithRouter(
              mockBloc: mockBloc,
              mockRouter: mockRouter,
            ),
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  await tester.pumpAndSettle();

                  final exchangeRateTitle = find.text(
                    S.current.searchExchangeRateTitle,
                  );
                  final exchangeRateCard = find.ancestor(
                    of: exchangeRateTitle,
                    matching: find.byType(CardCategorySelected),
                  );

                  expect(exchangeRateCard, findsOneWidget);
                  await tester.tap(exchangeRateCard);
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  verify(
                    () => mockRouter.goNamed(
                      BAPaths.exchangeRate.name,
                      extra: any(named: 'extra'),
                    ),
                  ).called(1);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'tap on exchange card navigates to exchange screen',
            buildWidget: () => _createSearchScreenWithRouter(
              mockBloc: mockBloc,
              mockRouter: mockRouter,
            ),
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  await tester.pumpAndSettle();

                  final exchangeTitle = find.text(
                    S.current.searchExchangeTitle,
                  );
                  final exchangeCard = find.ancestor(
                    of: exchangeTitle,
                    matching: find.byType(CardCategorySelected),
                  );

                  expect(exchangeCard, findsOneWidget);
                  await tester.tap(exchangeCard);
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  verify(
                    () => mockRouter.goNamed(
                      BAPaths.exchange.name,
                      extra: any(named: 'extra'),
                    ),
                  ).called(1);
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Card Order and Layout',
        scenarios: [
          BAWidgetTestScenario(
            description: 'cards are displayed in correct order',
            buildWidget: () => createSearchTestWidgetWithBloc(
              mockBloc: mockBloc,
              child: const SearchScreen(),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  await tester.pumpAndSettle();

                  final cards = find.byType(CardCategorySelected);
                  expect(cards, findsNWidgets(4));

                  // Get all card widgets
                  final cardWidgets = tester.widgetList<CardCategorySelected>(
                    cards,
                  );
                  final cardTitles = cardWidgets
                      .map((w) => w.category)
                      .toList();

                  // Verify order using S.current after widget is built
                  expect(cardTitles[0], S.current.searchBranchSelectedTitle);
                  expect(cardTitles[1], S.current.searchInterestRateTitle);
                  expect(cardTitles[2], S.current.searchExchangeRateTitle);
                  expect(cardTitles[3], S.current.searchExchangeTitle);
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Responsive Behavior',
        scenarios: [
          BAWidgetTestScenario(
            description: 'all cards are tappable',
            buildWidget: () => createSearchTestWidgetWithBloc(
              mockBloc: mockBloc,
              child: const SearchScreen(),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  await tester.pumpAndSettle();

                  final cards = find.byType(CardCategorySelected);
                  expect(cards, findsNWidgets(4));

                  // Verify all cards have GestureDetector/InkWell
                  for (final card in tester.widgetList<CardCategorySelected>(
                    cards,
                  )) {
                    expect(card.onTap, isNotNull);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ).test();
}

/// Helper to create SearchScreen with mocked GoRouter
Widget _createSearchScreenWithRouter({
  required MockSearchBloc mockBloc,
  required MockGoRouter mockRouter,
}) {
  return createSearchTestWidgetWithBloc(
    mockBloc: mockBloc,
    child: InheritedGoRouter(goRouter: mockRouter, child: const SearchScreen()),
  );
}
