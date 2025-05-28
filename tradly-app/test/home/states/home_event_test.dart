import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/presentations/pages/home/states/home_event.dart';

import '../../helper/utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });

  TAUnitTest(
    description: 'HomeEvt Test',
    features: [
      TAUTFeature(
        description: 'HomeInitializeEvt',
        scenarios: [
          HomeEvtPropsScenario(),
          HomeInitializeEvtPropsScenario(),
          HomeInitializeEvtWithToStringScenario(),
          HomeInitializeEvtEqualityScenario(),
        ],
      ),
    ],
  ).test();
}

class HomeInitializeEvtPropsScenario
    extends TAUTScenario<HomeEvt, List<Object?>> {
  HomeInitializeEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test HomeInitializeEvt Props
            Given HomeInitializeEvt event
            When creating a HomeInitializeEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return const HomeInitializeEvt(
              productId: 0,
            );
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(
              result,
              equals([0]),
            );
          },
        );
}

class HomeInitializeEvtWithToStringScenario
    extends TAUTScenario<HomeEvt, String> {
  HomeInitializeEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test toString function
          Given HomeInitializeEvt event
          When calling toString of HomeInitializeEvt event  is successful
           Then the output should be HomeInitializeEvt()
          ''',
          when: () async {
            return const HomeInitializeEvt(
              productId: 0,
            );
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(
              result,
              equals('HomeInitializeEvt(0)'),
            );
          },
        );
}

class HomeInitializeEvtEqualityScenario extends TAUTScenario<HomeEvt, bool> {
  HomeInitializeEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test equality of HomeInitializeEvt
          Given two HomeInitializeEvt event
          When comparing them
          Then they should be equal
          ''',
          when: () async {
            return const HomeInitializeEvt(
              productId: 0,
            );
          },
          act: (event) =>
              event ==
              const HomeInitializeEvt(
                productId: 0,
              ),
          expect: (bool result) {
            expect(result, isTrue);
          },
        );
}

class HomeEvtPropsScenario extends TAUTScenario<HomeEvt, List<Object?>> {
  HomeEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test HomeEvt Props
            Given HomeEvt event
            When creating a HomeEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return HomeEvt();
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, isEmpty);
          },
        );
}
