import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;

class BAWidgetTest {
  const BAWidgetTest({
    required this.description,
    required this.features,
    this.setUp,
    this.setUpAll,
    this.tearDown,
    this.tearDownAll,
  });

  final String description;
  final List<BAWidgetTestFeature> features;
  final FutureOr<void> Function()? setUp;
  final FutureOr<void> Function()? setUpAll;
  final FutureOr<void> Function()? tearDown;
  final FutureOr<void> Function()? tearDownAll;

  void test() {
    _setUpAndTeardown();

    flutter_test.group(description, () {
      for (var i = 0; i < features.length; i++) {
        features[i].test();
      }
    });
  }

  void _setUpAndTeardown() {
    if (setUpAll != null) {
      flutter_test.setUpAll(() => setUpAll?.call());
    }
    if (tearDownAll != null) {
      flutter_test.tearDownAll(() => tearDownAll?.call());
    }
    if (setUp != null) {
      flutter_test.setUp(() => setUp?.call());
    }
    if (tearDown != null) {
      flutter_test.tearDown(() => tearDown?.call());
    }
  }
}

class BAWidgetTestFeature {
  const BAWidgetTestFeature({
    required this.description,
    required this.scenarios,
  });

  final String description;
  final List<BAWidgetTestScenario> scenarios;

  void test() {
    flutter_test.group(description, () {
      for (var i = 0; i < scenarios.length; i++) {
        scenarios[i].test();
      }
    });
  }
}

class BAWidgetTestScenario {
  const BAWidgetTestScenario({
    required this.description,
    required this.buildWidget,
    this.setUp,
    this.interactions,
    this.verifications,
    this.tearDown,
    this.timeout,
  });

  final String description;
  final Widget Function() buildWidget;
  final FutureOr<void> Function(flutter_test.WidgetTester)? setUp;
  final List<BAWidgetInteraction>? interactions;
  final List<BAWidgetVerification>? verifications;
  final FutureOr<void> Function(flutter_test.WidgetTester)? tearDown;
  final Duration? timeout;

  Future<void> test() async {
    flutter_test.testWidgets(description, (
      flutter_test.WidgetTester tester,
    ) async {
      if (setUp != null) {
        await setUp!(tester);
      }

      await tester.pumpWidget(_wrapWidget(buildWidget()));

      if (interactions != null) {
        for (final interaction in interactions!) {
          await interaction.execute(tester);
        }
      }

      if (verifications != null) {
        for (final verification in verifications!) {
          await verification.execute(tester);
        }
      }

      if (tearDown != null) {
        await tearDown!(tester);
      }
    }, timeout: const flutter_test.Timeout(Duration(seconds: 5)));
  }

  Widget _wrapWidget(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }
}

// Base Classes
abstract class BAWidgetInteraction {
  const BAWidgetInteraction();
  Future<void> execute(flutter_test.WidgetTester tester);
}

abstract class BAWidgetVerification {
  const BAWidgetVerification();
  Future<void> execute(flutter_test.WidgetTester tester);
}

// Interactions
class BATapInteraction extends BAWidgetInteraction {
  const BATapInteraction({required this.finder, this.warnIfMissed = true});

  final flutter_test.Finder finder;
  final bool warnIfMissed;

  @override
  Future<void> execute(flutter_test.WidgetTester tester) async {
    await tester.tap(finder, warnIfMissed: warnIfMissed);
    await tester.pumpAndSettle();
  }
}

class BAEnterTextInteraction extends BAWidgetInteraction {
  const BAEnterTextInteraction({required this.finder, required this.text});

  final flutter_test.Finder finder;
  final String text;

  @override
  Future<void> execute(flutter_test.WidgetTester tester) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }
}

class BAScrollInteraction extends BAWidgetInteraction {
  const BAScrollInteraction({required this.finder, required this.offset});

  final flutter_test.Finder finder;
  final Offset offset;

  @override
  Future<void> execute(flutter_test.WidgetTester tester) async {
    await tester.drag(finder, offset);
    await tester.pumpAndSettle();
  }
}

class BAWaitInteraction extends BAWidgetInteraction {
  const BAWaitInteraction({required this.duration});

  final Duration duration;

  @override
  Future<void> execute(flutter_test.WidgetTester tester) async {
    await tester.pump(duration);
  }
}

class BACustomInteraction extends BAWidgetInteraction {
  const BACustomInteraction({required this.action});

  final Future<void> Function(flutter_test.WidgetTester tester) action;

  @override
  Future<void> execute(flutter_test.WidgetTester tester) async {
    await action(tester);
  }
}

// Verifications
class BAFindsWidgetVerification extends BAWidgetVerification {
  const BAFindsWidgetVerification({required this.finder, this.count});

  final flutter_test.Finder finder;
  final int? count;

  @override
  Future<void> execute(flutter_test.WidgetTester tester) async {
    if (count != null) {
      flutter_test.expect(finder, flutter_test.findsNWidgets(count!));
    } else {
      flutter_test.expect(finder, flutter_test.findsOneWidget);
    }
  }
}

class BAFindsTextVerification extends BAWidgetVerification {
  const BAFindsTextVerification({required this.text, this.count});

  final String text;
  final int? count;

  @override
  Future<void> execute(flutter_test.WidgetTester tester) async {
    final finder = flutter_test.find.text(text);
    if (count != null) {
      flutter_test.expect(finder, flutter_test.findsNWidgets(count!));
    } else {
      flutter_test.expect(finder, flutter_test.findsOneWidget);
    }
  }
}

class BADoesNotFindVerification extends BAWidgetVerification {
  const BADoesNotFindVerification({required this.finder});

  final flutter_test.Finder finder;

  @override
  Future<void> execute(flutter_test.WidgetTester tester) async {
    flutter_test.expect(finder, flutter_test.findsNothing);
  }
}

class BACustomVerification extends BAWidgetVerification {
  const BACustomVerification({required this.verification});

  final Future<void> Function(flutter_test.WidgetTester tester) verification;

  @override
  Future<void> execute(flutter_test.WidgetTester tester) async {
    await verification(tester);
  }
}
