import 'package:banking_app/features/transactions/blocs/transaction_bloc.dart';
import 'package:banking_app/features/transactions/blocs/transaction_event.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionReportBloc extends Mock implements TransactionReportBloc {}

void setupTransactionBlocFallbacks() {
  registerFallbackValue(const TransactionReportInitializeEvt());
  registerFallbackValue(const SetAnimationStatusEvt(false));
  registerFallbackValue(const ChangeCardIndexEvt(0));
}
