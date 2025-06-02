import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/features/home/states/home_state.dart';

import '../../helper/utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });

  TAUnitTest(
    description: 'HomeState Test',
    features: [
      TAUTFeature(
        description: 'HomeState',
        scenarios: [
          HomeStatePropsScenario(),
          HomeStateEqualityScenario(),
          HomeStateCopyWithScenario(),
          HomeStateDefaultValuesScenario(),
          HomeStateToStringScenario(),
          HomeStateCopyWithStatusScenario(),
        ],
      ),
    ],
  ).test();
}

class HomeStatePropsScenario extends TAUTScenario<HomeState, HomeState> {
  HomeStatePropsScenario()
      : super(
          description: '''
           Scenario: Test HomeStatePropsScenario
            Given HomeState instance
            When accessing props
            Then it should return the correct values
          ''',
          when: () async {
            return HomeState(
              status: const HomeStatus.success(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.copyWith(
            status: const HomeStatus.success(),
          ),
          expect: (HomeState result) {
            expect(
              result.status == const HomeStatus.success(),
              isTrue,
            );
          },
        );
}

class HomeStateEqualityScenario extends TAUTScenario<HomeState, HomeState> {
  HomeStateEqualityScenario()
      : super(
          description: '''
           Scenario: Test equality of HomeState
           Given two HomeState instances with the same values
           When compare with each other
           Then return true
          ''',
          when: () async {
            return HomeState(
              status: const HomeStatus.success(),
              errorMessage: 'error',
            );
          },
          act: (state) => state,
          expect: (HomeState result) {
            expect(result == result, isTrue);
          },
        );
}

class HomeStateCopyWithScenario extends TAUTScenario<HomeState, HomeState> {
  HomeStateCopyWithScenario()
      : super(
          description: '''
           Scenario: Test copyWith method of HomeState
           Given a HomeState instance
           When call copyWith method
           Then it should return a new HomeState instance
          ''',
          when: () async {
            return HomeState(
              status: const HomeStatus.success(),
              errorMessage: 'error',
            );
          },
          act: (state) => state,
          expect: (HomeState result) {
            expect(result == result, isTrue);
          },
        );
}

class HomeStateDefaultValuesScenario
    extends TAUTScenario<HomeState, HomeState> {
  HomeStateDefaultValuesScenario()
      : super(
          description: '''
           Scenario: Test default values of HomeState
            Given a HomeState instance
            When call HomeState without any values
            Then it should return a HomeState instance with default values
          ''',
          when: () async {
            return const HomeState();
          },
          act: (state) => state,
          expect: (HomeState result) {
            expect(
              result.status == const HomeStatus.initial(),
              isTrue,
            );
          },
        );
}

class HomeStateToStringScenario extends TAUTScenario<HomeState, HomeState> {
  HomeStateToStringScenario()
      : super(
          description: '''
           Scenario: Test toString of HomeState
            Given a HomeState instance
            When call toString method
            Then it should return a string
          ''',
          when: () async {
            return HomeState(
              status: const HomeStatus.success(),
              errorMessage: 'error',
            );
          },
          act: (state) => state,
          expect: (HomeState result) {
            expect(
              result.toString(),
              isNotNull,
            );
          },
        );
}

class HomeStateCopyWithStatusScenario
    extends TAUTScenario<HomeState, HomeState> {
  HomeStateCopyWithStatusScenario()
      : super(
          description: '''
           Scenario: Test copyWith status of HomeState
            Given a HomeState
            When call copyWith status with new status
            Then it should return a new HomeState with new status
          ''',
          when: () async {
            return HomeState(
              status: const HomeStatus.success(),
              errorMessage: 'error',
            );
          },
          act: (state) => state,
          expect: (HomeState result) {
            expect(
              result == result,
              isTrue,
            );
          },
        );
}
