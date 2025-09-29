import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:banking_app/features/transfer/states/transfer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../mocks/mock_transfer_bloc.dart';
import 'transfer_test_setup.dart';

Widget createTestWidget({
  required Widget child,
  Size surfaceSize = const Size(800, 1400),
}) {
  return ResponsiveBreakpoints.builder(
    child: MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(
          size: surfaceSize,
          padding: EdgeInsets.zero,
          devicePixelRatio: 1.0,
        ),
        child: child,
      ),
    ),
    breakpoints: const [
      Breakpoint(start: 0, end: 450, name: MOBILE),
      Breakpoint(start: 451, end: 800, name: TABLET),
      Breakpoint(start: 801, end: 1920, name: DESKTOP),
      Breakpoint(start: 1921, end: double.infinity, name: '4K'),
    ],
  );
}

Widget createTestWidgetWithBloc({
  required Widget child,
  required MockTransferBloc mockBloc,
  TransferState? initialState,
  Size surfaceSize = const Size(800, 1400),
}) {
  final state = initialState ?? createInitialTransferState();

  // Setup mock bloc
  setupMockBloc(mockBloc, state);
  setupServiceLocator(mockBloc);

  return createTestWidget(
    surfaceSize: surfaceSize,
    child: BlocProvider<TransferBloc>.value(value: mockBloc, child: child),
  );
}
