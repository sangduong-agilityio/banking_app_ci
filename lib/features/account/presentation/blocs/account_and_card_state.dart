import 'package:equatable/equatable.dart';
import 'package:banking_app/features/home/data/models/account_model.dart';
import 'package:banking_app/features/home/data/models/card_model.dart';
import 'package:banking_app/features/setting/data/models/user_model.dart';

enum AccountAndCardStatus { initial, loading, success, failure }

/// Represents the state of the account and card feature.
class AccountAndCardState extends Equatable {
  const AccountAndCardState({
    this.status = AccountAndCardStatus.initial,
    this.user,
    this.errorMessage,
    this.cards = const [],
    this.accounts = const [],
  });

  final AccountAndCardStatus status;
  final UserModel? user;
  final List<CardModel> cards;
  final List<AccountModel> accounts;
  final String? errorMessage;

  AccountAndCardState copyWith({
    AccountAndCardStatus? status,
    UserModel? user,
    String? errorMessage,
    List<CardModel>? cards,
    List<AccountModel>? accounts,
  }) {
    return AccountAndCardState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      cards: cards ?? this.cards,
      accounts: accounts ?? this.accounts,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, user, cards, accounts];
}
