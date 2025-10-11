import 'package:banking_app/features/transactions/blocs/transaction_bloc.dart';
import 'package:banking_app/features/transactions/blocs/transaction_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../helpers/widget_test_app.dart';
import '../mocks/mock_transactions_bloc.dart';
import 'transactions_test_setup.dart';

Widget createTransactionsTestWidget({
  required Widget child,
  Size surfaceSize = const Size(800, 1400),
}) {
  return BAWidgetTestApp(surfaceSize: surfaceSize, child: child);
}

Widget createTransactionsTestWidgetWithBloc({
  required Widget child,
  required MockTransactionReportBloc mockBloc,
  TransactionReportState? initialState,
  Size surfaceSize = const Size(800, 1400),
}) {
  final state = initialState ?? const TransactionReportState();

  setupMockTransactionBloc(mockBloc, state);
  setupTransactionServiceLocator(mockBloc);

  return createTransactionsTestWidget(
    surfaceSize: surfaceSize,
    child: BlocProvider<TransactionReportBloc>.value(
      value: mockBloc,
      child: child,
    ),
  );
}

Widget createTestWidget({
  required Widget child,
  Size surfaceSize = const Size(800, 1400),
}) => createTransactionsTestWidget(child: child, surfaceSize: surfaceSize);

Widget createTestWidgetWithBloc({
  required Widget child,
  required MockTransactionReportBloc mockBloc,
  TransactionReportState? initialState,
  Size surfaceSize = const Size(800, 1400),
}) => createTransactionsTestWidgetWithBloc(
  child: child,
  mockBloc: mockBloc,
  initialState: initialState,
  surfaceSize: surfaceSize,
);
