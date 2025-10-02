import 'package:banking_app/features/transactions/repositories/transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionReportBloc
    extends Bloc<TransactionReportEvt, TransactionReportState> {
  TransactionReportBloc({required this.repo})
    : super(const TransactionReportState()) {
    on<TransactionReportInitializeEvt>(_onTransactionReportInitialize);
    on<ChangeCardIndexEvt>(_onChangeCardIndex);
    on<SetAnimationStatusEvt>(_onSetAnimationStatus);
  }

  final TransactionReportRepository repo;

  Future<void> _onTransactionReportInitialize(
    TransactionReportInitializeEvt event,
    Emitter<TransactionReportState> emit,
  ) async {
    emit(state.copyWith(status: const TransactionReportStatus.loading()));
    try {
      final cards = await repo.fetchCards();
      final report = await repo.fetchTransactionReports();

      emit(
        state.copyWith(
          status: const TransactionReportStatus.success(),
          cards: cards,
          transactionReport: report,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const TransactionReportStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onChangeCardIndex(
    ChangeCardIndexEvt event,
    Emitter<TransactionReportState> emit,
  ) async {
    emit(state.copyWith(selectedCardIndex: event.index));
  }

  Future<void> _onSetAnimationStatus(
    SetAnimationStatusEvt event,
    Emitter<TransactionReportState> emit,
  ) async {
    emit(state.copyWith(shouldPlayAnimation: event.shouldPlay));
  }
}
