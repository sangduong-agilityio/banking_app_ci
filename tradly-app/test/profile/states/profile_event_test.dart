import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/presentations/pages/profile/states/profile_event.dart';

import '../../helper/utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });
  TAUnitTest(
    description: 'ProfileEvt Test',
    features: [
      TAUTFeature(
        description: 'ProfileEvt',
        scenarios: [
          ProfileEvtPropsScenario(),
        ],
      ),
      TAUTFeature(
        description: 'FetchProfileEvt',
        scenarios: [
          FetchProfileEvtPropsScenario(),
          FetchProfileEvtWithToStringScenario(),
          FetchProfileEvtEqualityScenario(),
        ],
      ),
    ],
  ).test();
}

class ProfileEvtPropsScenario extends TAUTScenario<ProfileEvt, List<Object?>> {
  ProfileEvtPropsScenario()
      : super(
          description: '''
    Scenario: Test ProfileEvt Props
            Given ProfileEvt event
            When creating a ProfileEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return ProfileEvt();
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, isEmpty);
          },
        );
}

class FetchProfileEvtPropsScenario
    extends TAUTScenario<FetchProfileEvt, List<Object?>> {
  FetchProfileEvtPropsScenario()
      : super(
          description: '''
    Scenario: Test FetchProfileEvt Props
            Given FetchProfileEvt event
            When creating a FetchProfileEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return FetchProfileEvt();
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, isEmpty);
          },
        );
}

class FetchProfileEvtWithToStringScenario
    extends TAUTScenario<FetchProfileEvt, String> {
  FetchProfileEvtWithToStringScenario()
      : super(
          description: '''
    Scenario: Test FetchProfileEvt with toString
            Given FetchProfileEvt event
            When creating a FetchProfileEvt event and accessing toString
            Then the toString should be FetchProfileEvt
            ''',
          when: () async {
            return FetchProfileEvt();
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, 'FetchProfileEvt()');
          },
        );
}

class FetchProfileEvtEqualityScenario
    extends TAUTScenario<FetchProfileEvt, bool> {
  FetchProfileEvtEqualityScenario()
      : super(
          description: '''
    Scenario: Test FetchProfileEvt Equality
            Given FetchProfileEvt event
            When creating a FetchProfileEvt event and accessing ==
            Then the == should be true
            ''',
          when: () async {
            return FetchProfileEvt();
          },
          act: (event) => event == FetchProfileEvt(),
          expect: (bool result) {
            expect(result, true);
          },
        );
}
