import 'package:banking_app/features/dashboard/models/card_model.dart';
import 'package:equatable/equatable.dart';

abstract class DashBoardEvt extends Equatable {
  const DashBoardEvt();

  @override
  List<Object?> get props => [];
}

class UserLoadCardEvt extends DashBoardEvt {
  final String userId;

  const UserLoadCardEvt(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UserAddCardEvt extends DashBoardEvt {
  final CardModel card;

  const UserAddCardEvt(this.card);

  @override
  List<Object?> get props => [card];
}

class UserUpdateCardEvt extends DashBoardEvt {
  final CardModel card;

  const UserUpdateCardEvt(this.card);

  @override
  List<Object?> get props => [card];
}

class UserDeleteCardEvt extends DashBoardEvt {
  final String cardId;

  const UserDeleteCardEvt(this.cardId);

  @override
  List<Object?> get props => [cardId];
}

class UserSetDefaultCard extends DashBoardEvt {
  final String cardId;

  const UserSetDefaultCard(this.cardId);

  @override
  List<Object?> get props => [cardId];
}

class UserRefreshCards extends DashBoardEvt {
  final String userId;

  const UserRefreshCards(this.userId);

  @override
  List<Object?> get props => [userId];
}
