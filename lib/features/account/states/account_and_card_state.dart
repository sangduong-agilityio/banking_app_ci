import 'package:banking_app/features/home/models/account_model.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:banking_app/features/setting/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_and_card_state.freezed.dart';

class AccountAndCardState extends Equatable {
  const AccountAndCardState({
    this.status = const AccountAndCardStatus.initial(),
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

@freezed
sealed class AccountAndCardStatus with _$AccountAndCardStatus {
  const factory AccountAndCardStatus.initial() = AccountAndCardStatusInitial;
  const factory AccountAndCardStatus.loading() = AccountAndCardStatusLoading;
  const factory AccountAndCardStatus.success() = AccountAndCardStatusSuccess;
  const factory AccountAndCardStatus.failure() = AccountAndCardStatusFailure;
}
