import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/features/home/data/models/card_model.dart';
import 'package:banking_app/features/transactions/presentation/blocs/transaction_bloc.dart';
import 'package:banking_app/features/transactions/data/models/transaction_report_model.dart';
import 'package:banking_app/features/transactions/presentation/blocs/transaction_event.dart';
import 'package:banking_app/features/transactions/presentation/blocs/transaction_state.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/mock_transactions_bloc.dart';

TransactionReportState createInitialTransactionState({
  TransactionReportStatus? status,
  List<CardModel>? cards,
  TransactionReportModel? report,
  String? errorMessage,
}) {
  return TransactionReportState(
    status: status ?? const TransactionReportStatus.initial(),
    cards: cards ?? const <CardModel>[],
    transactionReport: report,
    errorMessage: errorMessage,
  );
}

void setupMockTransactionBloc(
  MockTransactionReportBloc mockBloc,
  TransactionReportState state,
) {
  when(() => mockBloc.state).thenReturn(state);
  when(() => mockBloc.stream).thenAnswer((_) => Stream.value(state));
  when(() => mockBloc.add(any())).thenReturn(null);
  when(() => mockBloc.close()).thenAnswer((_) async {});
}

void setupTransactionServiceLocator(MockTransactionReportBloc mockBloc) {
  final getIt = GetIt.instance;
  if (getIt.isRegistered<TransactionReportBloc>()) {
    getIt.unregister<TransactionReportBloc>();
  }
  locator.registerFactory<TransactionReportBloc>(() => mockBloc);
}

void cleanupTransactionServiceLocator() {
  final getIt = GetIt.instance;
  if (getIt.isRegistered<TransactionReportBloc>()) {
    getIt.unregister<TransactionReportBloc>();
  }
}

void setupTransactionFallbacks() {
  registerFallbackValue(const TransactionReportInitializeEvt());
  registerFallbackValue(const SetAnimationStatusEvt(false));
  registerFallbackValue(const ChangeCardIndexEvt(0));
}
