import 'dart:async';
import 'package:bloc_test/bloc_test.dart' as bloc_test;
import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:banking_app/features/transfer/blocs/transfer_bloc.dart';
import '../features/transfer/mocks/mock_transfer_bloc.dart';

final exceptionMock = Exception('oops');
final requestOptionsMock = RequestOptions(path: faker.lorem.word());

/// Widget Test Framework
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
    if (setUpAll != null) flutter_test.setUpAll(() => setUpAll?.call());
    if (tearDownAll != null) {
      flutter_test.tearDownAll(() => tearDownAll?.call());
    }
    if (setUp != null) flutter_test.setUp(() => setUp?.call());
    if (tearDown != null) flutter_test.tearDown(() => tearDown?.call());
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
    this.mockTransferBloc,
  });

  final String description;
  final Widget Function() buildWidget;
  final FutureOr<void> Function(flutter_test.WidgetTester)? setUp;
  final List<BAWidgetInteraction>? interactions;
  final List<BAWidgetVerification>? verifications;
  final FutureOr<void> Function(flutter_test.WidgetTester)? tearDown;
  final Duration? timeout;
  final MockTransferBloc? mockTransferBloc;

  Future<void> test() async {
    flutter_test.testWidgets(description, (
      flutter_test.WidgetTester tester,
    ) async {
      if (setUp != null) await setUp!(tester);
      await tester.pumpWidget(
        _wrapWidget(buildWidget(), mockTransferBloc: mockTransferBloc),
      );
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
      if (tearDown != null) await tearDown!(tester);
    }, timeout: const flutter_test.Timeout(Duration(seconds: 5)));
  }

  Widget _wrapWidget(Widget child, {MockTransferBloc? mockTransferBloc}) {
    return MaterialApp(
      home: ResponsiveBreakpoints.builder(
        child: BlocProvider<TransferBloc>(
          create: (context) => mockTransferBloc ?? MockTransferBloc(),
          child: Scaffold(body: child),
        ),
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: MOBILE),
          Breakpoint(start: 451, end: 800, name: TABLET),
          Breakpoint(start: 801, end: 1920, name: DESKTOP),
          Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}

abstract class BAWidgetInteraction {
  const BAWidgetInteraction();
  Future<void> execute(flutter_test.WidgetTester tester);
}

abstract class BAWidgetVerification {
  const BAWidgetVerification();
  Future<void> execute(flutter_test.WidgetTester tester);
}

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

/// Unit Test Framework

class BAUnitTest {
  const BAUnitTest({
    required this.description,
    required this.features,
    this.setUp,
    this.setUpAll,
    this.tearDown,
    this.tearDownAll,
  });

  final String description;
  final List<BAUTFeature> features;
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
    if (setUpAll != null) flutter_test.setUpAll(setUpAll!);
    if (tearDownAll != null) flutter_test.tearDownAll(tearDownAll!);
    if (setUp != null) flutter_test.setUp(setUp!);
    if (tearDown != null) flutter_test.tearDown(tearDown!);
  }
}

class BAUTFeature {
  const BAUTFeature({required this.description, required this.scenarios});
  final String description;
  final List<BAUTScenario> scenarios;

  void test() {
    flutter_test.group(description, () {
      for (var i = 0; i < scenarios.length; i++) {
        scenarios[i].test();
      }
    });
  }
}

class BAUTScenario<T, R> {
  const BAUTScenario({
    required this.description,
    required this.act,
    required this.when,
    required this.expect,
  });

  final String description;
  final FutureOr<T> Function() when;
  final FutureOr<dynamic> Function(T result) act;
  final FutureOr<void> Function(R result) expect;

  Future<void> test() async {
    flutter_test.test(description, () async {
      final res = await when();
      final result = await act(res) as R;
      expect(result);
    });
  }
}

class TAUTStep {
  const TAUTStep({required this.act, required this.expect, this.when});
  final Function? when;
  final Function act;
  final Function expect;
}

class BABlocTest {
  const BABlocTest({
    required this.description,
    required this.features,
    this.setUp,
    this.setUpAll,
    this.tearDown,
    this.tearDownAll,
  });

  final String description;
  final List<BABlocTestFeature> features;
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
    if (setUpAll != null) flutter_test.setUpAll(() => setUpAll?.call());
    if (tearDownAll != null) {
      flutter_test.tearDownAll(() => tearDownAll?.call());
    }
    if (setUp != null) flutter_test.setUp(() => setUp?.call());
    if (tearDown != null) flutter_test.tearDown(() => tearDown?.call());
  }
}

class BABlocTestFeature {
  const BABlocTestFeature({required this.description, required this.scenarios});

  final String description;
  final List<BABlocTestScenario> scenarios;

  void test() {
    flutter_test.group(description, () {
      for (var i = 0; i < scenarios.length; i++) {
        scenarios[i].test();
      }
    });
  }
}

class BABlocTestScenario<B extends BlocBase<State>, State> {
  const BABlocTestScenario({
    required this.description,
    required this.build,
    this.setUp,
    this.act,
    this.seed,
    this.wait,
    this.expect,
    this.verify,
    this.errors,
    this.tearDown,
  });

  final String description;
  final B Function() build;
  final FutureOr<void> Function()? setUp;
  final void Function(B)? act;
  final State Function()? seed;
  final Duration? wait;
  final dynamic Function()? expect;
  final void Function(B)? verify;
  final void Function()? errors;
  final FutureOr<void> Function()? tearDown;

  Future<void> test() async {
    bloc_test.blocTest<B, State>(
      description,
      build: build,
      act: act,
      seed: seed,
      setUp: setUp,
      wait: wait,
      verify: verify,
      expect: expect,
      tearDown: tearDown,
    );
  }
}

/// Mocktail Extensions

extension VoidAnswer on When<Future<void>> {
  void thenAnswerWithVoid() => thenAnswer((_) async {});
}

extension ThenThrowException on When<Future> {
  void thenThrowException() => thenThrow(exceptionMock);
}

extension ThenAnswerResponseFutureValue<T> on When<Future<Response<T>>> {
  void thenAnswerValue(T value) => thenAnswer(
    (_) =>
        Future.value(Response(requestOptions: requestOptionsMock, data: value)),
  );
}

extension ThenAnswerFutureValue<T> on When<Future<T>> {
  void thenAnswerValue(T value) => thenAnswer((_) => Future.value(value));
}

extension ThenTaskEitherAnswerValue<T, F> on When<TaskEither<T, F>> {
  void thenAnswerValue(F value) => thenAnswer((_) => TaskEither.right(value));
  void thenAnswerFailureValue(T value) =>
      thenAnswer((_) => TaskEither.left(value));
}
