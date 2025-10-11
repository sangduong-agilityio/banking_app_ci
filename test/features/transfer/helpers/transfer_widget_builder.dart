import 'package:banking_app/features/transfer/blocs/transfer_bloc.dart';
import 'package:banking_app/features/transfer/blocs/transfer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../helpers/widget_test_app.dart';
import '../mocks/mock_transfer_bloc.dart';
import 'transfer_test_setup.dart';

Widget createTestWidget({
  required Widget child,
  Size surfaceSize = const Size(800, 1400),
}) {
  return BAWidgetTestApp(surfaceSize: surfaceSize, child: child);
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
