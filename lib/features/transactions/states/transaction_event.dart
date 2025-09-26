import 'package:equatable/equatable.dart';

abstract class TransactionReportEvt extends Equatable {
  const TransactionReportEvt();

  @override
  List<Object?> get props => [];
}

class TransactionReportInitializeEvt extends TransactionReportEvt {
  const TransactionReportInitializeEvt();

  @override
  List<Object?> get props => [];
}

class ChangeCardIndexEvt extends TransactionReportEvt {
  final int index;
  const ChangeCardIndexEvt(this.index);

  @override
  List<Object?> get props => [index];
}

class SetAnimationStatusEvt extends TransactionReportEvt {
  const SetAnimationStatusEvt(this.shouldPlay);

  final bool shouldPlay;

  @override
  List<Object?> get props => [shouldPlay];
}
