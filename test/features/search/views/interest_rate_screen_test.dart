import 'package:banking_app/features/search/models/interest_rate_model.dart';
import 'package:banking_app/features/search/states/search_state.dart';
import 'package:banking_app/features/search/views/interest_rate_screen.dart';
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
        description: 'UI States',
        scenarios: [
          BAWidgetTestScenario(
            description: 'shows title and table when success',
            buildWidget: () {
              final state = const SearchState(
                status: SearchStatus.success(),
                interestRates: [
                  InterestRateModel(type: 'Savings', period: '12m', rate: '5%'),
                ],
              );
              when(() => mockBloc.state).thenReturn(state);
              when(
                () => mockBloc.stream,
              ).thenAnswer((_) => Stream.value(state));
              return createSearchTestWidgetWithBloc(
                mockBloc: mockBloc,
                child: const InterestRateScreen(),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  BAFindsTextVerification(text: '"Interest kind');
                  BAFindsTextVerification(text: 'Period"');
                  BAFindsTextVerification(text: 'Rate"');
                  BAFindsTextVerification(text: 'Savings');
                  BAFindsTextVerification(text: '12m');
                  BAFindsTextVerification(text: '5%');
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ).test();
}
