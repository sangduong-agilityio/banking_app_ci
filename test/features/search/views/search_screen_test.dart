import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/search/views/search_screen.dart';
import 'package:flutter_test/flutter_test.dart';

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
    description: 'SearchScreen Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'UI Components Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display title and search cards',
            buildWidget: () => createSearchTestWidgetWithBloc(
              mockBloc: mockBloc,
              child: const SearchScreen(),
            ),
            verifications: [
              BAFindsTextVerification(text: S.current.searchTitle),
              BAFindsTextVerification(text: S.current.searchExchangeRateTitle),
              BAFindsTextVerification(text: S.current.searchExchangeTitle),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Navigation',
        scenarios: [
          BAWidgetTestScenario(
            description: 'tap on exchange rate card navigates',
            buildWidget: () => createSearchTestWidgetWithBloc(
              mockBloc: mockBloc,
              child: const SearchScreen(),
            ),
            interactions: [
              BATapInteraction(
                finder: find.text(S.current.searchExchangeRateTitle),
              ),
              const BAWaitInteraction(duration: Duration(milliseconds: 200)),
            ],
            verifications: const [
              BAFindsTextVerification(text: 'Exchange Rate'),
            ],
          ),
        ],
      ),
    ],
  ).test();
}
