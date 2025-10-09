import 'package:equatable/equatable.dart';

/// The base class for all events related to the transaction report feature.
abstract class TransactionReportEvt extends Equatable {
  const TransactionReportEvt();

  @override
  List<Object?> get props => [];
}

/// An event that signals the initialization of the transaction report.
class TransactionReportInitializeEvt extends TransactionReportEvt {
  const TransactionReportInitializeEvt();

  @override
  List<Object?> get props => [];
}

/// An event that signals a change in the selected card index.
class ChangeCardIndexEvt extends TransactionReportEvt {
  final int index;
  const ChangeCardIndexEvt(this.index);

  @override
  List<Object?> get props => [index];
}

/// An event that signals a change in the animation status.
class SetAnimationStatusEvt extends TransactionReportEvt {
  const SetAnimationStatusEvt(this.shouldPlay);

  final bool shouldPlay;

  @override
  List<Object?> get props => [shouldPlay];
}
