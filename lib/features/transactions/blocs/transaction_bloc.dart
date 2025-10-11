import 'package:banking_app/features/transactions/repositories/transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

/// A BLoC that manages the state of the transaction report feature.
class TransactionReportBloc
    extends Bloc<TransactionReportEvt, TransactionReportState> {
  TransactionReportBloc({required this.repo})
    : super(const TransactionReportState()) {
    on<TransactionReportInitializeEvt>(_onTransactionReportInitialize);
    on<ChangeCardIndexEvt>(_onChangeCardIndex);
    on<SetAnimationStatusEvt>(_onSetAnimationStatus);
  }

  final TransactionReportRepository repo;

  /// Handles the initialization of the transaction report.
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

  /// Handles changes to the selected card index.
  void _onChangeCardIndex(
    ChangeCardIndexEvt event,
    Emitter<TransactionReportState> emit,
  ) {
    emit(state.copyWith(selectedCardIndex: event.index));
  }

  /// Handles changes to the animation status.
  void _onSetAnimationStatus(
    SetAnimationStatusEvt event,
    Emitter<TransactionReportState> emit,
  ) {
    emit(state.copyWith(shouldPlayAnimation: event.shouldPlay));
  }
}
