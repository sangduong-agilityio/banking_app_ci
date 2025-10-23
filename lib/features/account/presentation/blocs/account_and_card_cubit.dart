import 'package:banking_app/features/account/presentation/blocs/account_and_card_state.dart';
import 'package:banking_app/features/home/data/repositories/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A Cubit for managing the state of the account and card feature.
///
/// This Cubit is responsible for fetching the user's accounts and cards.
class AccountAndCardCubit extends Cubit<AccountAndCardState> {
  AccountAndCardCubit({required this.repo})
    : super(const AccountAndCardState());

  /// The repository for fetching home-related data.
  final HomeRepository repo;

  /// Initializes the account and card feature by fetching the user, cards, and accounts.
  Future<void> accountAndCardInitialize() async {
    emit(state.copyWith(status: const AccountAndCardStatus.loading()));
    try {
      final user = await repo.fetchCurrentUser();
      final cards = await repo.fetchCards();
      final accounts = await repo.fetchAccounts();

      emit(
        state.copyWith(
          user: user,
          cards: cards,
          accounts: accounts,
          status: const AccountAndCardStatus.success(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const AccountAndCardStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Gets the balance for an account with the specified [accountId].
  /// Returns null if the account is not found.
  double? getBalance(String accountId) {
    final account = state.accounts.firstWhere(
      (account) => account.id == accountId,
      orElse: () => throw Exception('Account not found'),
    );
    return account.availableBalance;
  }
}
