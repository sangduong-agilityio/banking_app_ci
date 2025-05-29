import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/presentations/pages/browse/states/browse_event.dart';

import '../../helper/utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });
  TAUnitTest(
    description: 'BrowseEvt Test',
    features: [
      TAUTFeature(
        description: 'BrowseEvt',
        scenarios: [
          BrowseEvtPropsScenario(),
        ],
      ),
      TAUTFeature(
        description: 'BrowseInitializeEvt',
        scenarios: [
          BrowseInitializeEvtPropsScenario(),
          BrowseInitializeEvtWithToStringScenario(),
          BrowseInitializeEvtEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'BrowseSearchEvt',
        scenarios: [
          BrowseSearchEvtPropsScenario(),
          BrowseSearchEvtWithToStringScenario(),
          BrowseSearchEvtEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'BrowseSortEvt',
        scenarios: [
          BrowseSortEvtPropsScenario(),
          BrowseSortEvtWithToStringScenario(),
          BrowseSortEvtEqualityScenario(),
        ],
      )
    ],
  ).test();
}

class BrowseEvtPropsScenario extends TAUTScenario<BrowseEvt, List<Object?>> {
  BrowseEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test BrowseEvt Props
            Given BrowseEvt event
            When creating a ProductDetailEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return BrowseEvt();
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, isEmpty);
          },
        );
}

class BrowseInitializeEvtPropsScenario
    extends TAUTScenario<BrowseInitializeEvt, List<Object?>> {
  BrowseInitializeEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test BrowseInitializeEvt Props
            Given BrowseInitializeEvt event
            When creating a ProductDetailEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return BrowseInitializeEvt();
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, isEmpty);
          },
        );
}

class BrowseInitializeEvtWithToStringScenario
    extends TAUTScenario<BrowseInitializeEvt, String> {
  BrowseInitializeEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test BrowseInitializeEvt with toString
            Given BrowseInitializeEvt event
            When creating a ProductDetailEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return BrowseInitializeEvt();
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class BrowseInitializeEvtEqualityScenario
    extends TAUTScenario<BrowseInitializeEvt, bool> {
  BrowseInitializeEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test BrowseInitializeEvt Equality
            Given BrowseInitializeEvt event
            When creating a ProductDetailEvt event and accessing ==
            Then the == should be true
            ''',
          when: () async {
            return BrowseInitializeEvt();
          },
          act: (event) => event == BrowseInitializeEvt(),
          expect: (bool result) {
            expect(result, true);
          },
        );
}

class BrowseSearchEvtPropsScenario
    extends TAUTScenario<BrowseSearchEvt, List<Object?>> {
  BrowseSearchEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test BrowseSearchEvt Props
            Given BrowseSearchEvt event
            When creating a ProductDetailEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return BrowseSearchEvt(
              query: 'query',
            );
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, ['query']);
          },
        );
}

class BrowseSearchEvtWithToStringScenario
    extends TAUTScenario<BrowseSearchEvt, String> {
  BrowseSearchEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test BrowseSearchEvt with toString
            Given BrowseSearchEvt event
            When creating a ProductDetailEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return BrowseSearchEvt(
              query: 'query',
            );
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class BrowseSearchEvtEqualityScenario
    extends TAUTScenario<BrowseSearchEvt, bool> {
  BrowseSearchEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test BrowseSearchEvt Equality
            Given BrowseSearchEvt event
            When creating a ProductDetailEvt event and accessing ==
            Then the == should be true
            ''',
          when: () async {
            return BrowseSearchEvt(
              query: 'query',
            );
          },
          act: (event) => event == BrowseSearchEvt(query: 'query'),
          expect: (bool result) {
            expect(result, true);
          },
        );
}

class BrowseSortEvtPropsScenario
    extends TAUTScenario<BrowseSortEvt, List<Object?>> {
  BrowseSortEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test BrowseSortEvt Props
            Given BrowseSortEvt event
            When creating a ProductDetailEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return BrowseSortEvt(
              sort: SortOrder.lowToHigh,
            );
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, [SortOrder.lowToHigh]);
          },
        );
}

class BrowseSortEvtWithToStringScenario
    extends TAUTScenario<BrowseSortEvt, String> {
  BrowseSortEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test BrowseSortEvt with toString
            Given BrowseSortEvt event
            When creating a ProductDetailEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return BrowseSortEvt(
              sort: SortOrder.lowToHigh,
            );
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class BrowseSortEvtEqualityScenario extends TAUTScenario<BrowseSortEvt, bool> {
  BrowseSortEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test BrowseSortEvt Equality
            Given BrowseSortEvt event
            When creating a ProductDetailEvt event and accessing ==
            Then the == should be true
            ''',
          when: () async {
            return BrowseSortEvt(
              sort: SortOrder.lowToHigh,
            );
          },
          act: (event) => event == BrowseSortEvt(sort: SortOrder.lowToHigh),
          expect: (bool result) {
            expect(result, true);
          },
        );
}
