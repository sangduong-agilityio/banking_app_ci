import 'package:banking_app/features/transactions/models/transaction_report_model.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../home/models/card_model.dart';

part 'transaction_state.freezed.dart';

class TransactionReportState extends Equatable {
  const TransactionReportState({
    this.status = const TransactionReportStatus.initial(),
    this.cards = const [],
    this.selectedCardIndex = 0,
    this.shouldPlayAnimation = false,
    this.transactionReport,
    this.errorMessage,
  });

  final TransactionReportStatus status;
  final TransactionReportModel? transactionReport;
  final List<CardModel> cards;
  final String? errorMessage;
  final int selectedCardIndex;
  final bool shouldPlayAnimation;

  TransactionReportState copyWith({
    TransactionReportStatus? status,
    TransactionReportModel? transactionReport,
    List<CardModel>? cards,
    int? selectedCardIndex,
    bool? shouldPlayAnimation,
    String? errorMessage,
  }) {
    return TransactionReportState(
      status: status ?? this.status,
      transactionReport: transactionReport ?? this.transactionReport,
      cards: cards ?? this.cards,
      selectedCardIndex: selectedCardIndex ?? this.selectedCardIndex,
      shouldPlayAnimation: shouldPlayAnimation ?? this.shouldPlayAnimation,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    transactionReport,
    cards,
    selectedCardIndex,
    shouldPlayAnimation,
    errorMessage,
  ];
}

@freezed
sealed class TransactionReportStatus with _$TransactionReportStatus {
  const factory TransactionReportStatus.initial() =
      TransactionReportStatusInitial;
  const factory TransactionReportStatus.loading() =
      TransactionReportStatusLoading;
  const factory TransactionReportStatus.success() =
      TransactionReportStatusSuccess;
  const factory TransactionReportStatus.failure() =
      TransactionReportStatusFailure;
}
