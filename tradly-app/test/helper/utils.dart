import 'dart:async';

import 'package:bloc_test/bloc_test.dart' as bloc_test;
import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

final exceptionMock = Exception('oops');

final requestOptionsMock = RequestOptions(
  path: faker.lorem.word(),
);

class TAUnitTest {
  const TAUnitTest({
    required this.description,
    required this.features,
    this.setUp,
    this.setUpAll,
    this.tearDown,
    this.tearDownAll,
  });
  final String description;
  final List<TAUTFeature> features;
  final FutureOr<void> Function()? setUp;
  final FutureOr<void> Function()? setUpAll;
  final FutureOr<void> Function()? tearDown;
  final FutureOr<void> Function()? tearDownAll;

  /// Runs all test methods.
  void test() {
    // Runs setup/teardown/setupAll/teardownAll function
    _setUpAndTeardown();

    flutter_test.group(
      description,
      () {
        for (var i = 0; i < features.length; i++) {
          features[i].test();
        }
      },
    );
  }

  /// Runs any provided [setUp, setUpAll, tearDown, tearDownAll] methods.
  void _setUpAndTeardown() {
    if (setUpAll != null) {
      flutter_test.setUpAll(setUpAll!);
    }
    if (tearDownAll != null) {
      flutter_test.tearDownAll(tearDownAll!);
    }
    if (setUp != null) {
      flutter_test.setUp(setUp!);
    }
    if (tearDown != null) {
      flutter_test.tearDown(tearDown!);
    }
  }
}

class TABlocTest {
  const TABlocTest({
    required this.description,
    required this.features,
    this.setUp,
    this.setUpAll,
    this.tearDown,
    this.tearDownAll,
  });
  final String description;
  final List<TABlocTestFeature> features;
  final FutureOr<void> Function()? setUp;
  final FutureOr<void> Function()? setUpAll;
  final FutureOr<void> Function()? tearDown;
  final FutureOr<void> Function()? tearDownAll;

  /// Runs all test methods.
  void test() {
    // Runs setup/teardown/setupAll/teardownAll function
    _setUpAndTeardown();

    flutter_test.group(
      description,
      () {
        for (var i = 0; i < features.length; i++) {
          features[i].test();
        }
      },
    );
  }

  /// Runs any provided [setUp, setUpAll, tearDown, tearDownAll] methods.
  void _setUpAndTeardown() {
    if (setUpAll != null) {
      flutter_test.setUpAll(
        () => setUpAll?.call(),
      );
    }
    if (tearDownAll != null) {
      flutter_test.tearDownAll(
        () => tearDownAll?.call(),
      );
    }
    if (setUp != null) {
      flutter_test.setUp(
        () => setUp?.call(),
      );
    }
    if (tearDown != null) {
      flutter_test.tearDown(
        () => tearDown?.call(),
      );
    }
  }
}

class TAUTFeature {
  const TAUTFeature({
    required this.description,
    required this.scenarios,
  });
  final String description;
  final List<TAUTScenario> scenarios;

  void test() {
    flutter_test.group(
      description,
      () {
        for (var i = 0; i < scenarios.length; i++) {
          scenarios[i].test();
        }
      },
    );
  }
}

class TABlocTestFeature {
  const TABlocTestFeature({
    required this.description,
    required this.scenarios,
  });
  final String description;
  final List<TABlocTestScenario> scenarios;

  void test() {
    flutter_test.group(
      description,
      () {
        for (var i = 0; i < scenarios.length; i++) {
          scenarios[i].test();
        }
      },
    );
  }
}

class TABlocTestScenario<B extends BlocBase<State>, State> {
  const TABlocTestScenario({
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
  final void Function()? expect;
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
    );
  }
}

class TAUTScenario<T, R> {
  const TAUTScenario({
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
  const TAUTStep({
    required this.act,
    required this.expect,
    this.when,
  });

  final Function? when;
  final Function act;
  final Function expect;
}

extension VoidAnswer on When<Future<void>> {
  void thenAnswerWithVoid() => thenAnswer((_) async {});
}

extension ThenThrowException on When<Future> {
  void thenThrowException() => thenThrow(exceptionMock);
}

extension ThenAnswerResponseFutureValue<T> on When<Future<Response<T>>> {
  void thenAnswerValue(T value) => thenAnswer(
        (_) => Future.value(
          Response(
            requestOptions: requestOptionsMock,
            data: value,
          ),
        ),
      );
}

extension ThenAnswerFutureValue<T> on When<Future<T>> {
  void thenAnswerValue(T value) => thenAnswer(
        (_) => Future.value(
          value,
        ),
      );
}

extension ThenTaskEitherAnswerValue<T, F> on When<TaskEither<T, F>> {
  void thenAnswerValue(F value) => thenAnswer(
        (_) => TaskEither.right(value),
      );

  void thenAnswerFailureValue(T value) => thenAnswer(
        (_) => TaskEither.left(value),
      );
}
