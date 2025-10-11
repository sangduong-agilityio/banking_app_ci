import 'package:banking_app/features/bill_payment/blocs/bill_payment_bloc.dart';
import 'package:banking_app/features/bill_payment/blocs/bill_payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/widget_test_app.dart';
import '../mocks/mock_bill_payment_bloc.dart';
import 'bill_payment_test_setup.dart';

Widget createBillPayTestWidget({
  required Widget child,
  Size surfaceSize = const Size(800, 1400),
}) {
  return BAWidgetTestApp(surfaceSize: surfaceSize, child: child);
}

Widget createBillPayTestWidgetWithBloc({
  required Widget child,
  required MockBillPaymentBloc mockBloc,
  BillPaymentState? initialState,
  Size surfaceSize = const Size(800, 1400),
}) {
  final state =
      initialState ??
      const BillPaymentState(status: BillPaymentStatus.initial());
  when(() => mockBloc.state).thenReturn(state);
  when(() => mockBloc.stream).thenAnswer((_) => Stream.value(state));
  when(() => mockBloc.add(any())).thenReturn(null);
  when(() => mockBloc.close()).thenAnswer((_) async {});
  setupBillPaymentServiceLocator(mockBloc);

  return createBillPayTestWidget(
    surfaceSize: surfaceSize,
    child: BlocProvider<BillPaymentBloc>.value(value: mockBloc, child: child),
  );
}
