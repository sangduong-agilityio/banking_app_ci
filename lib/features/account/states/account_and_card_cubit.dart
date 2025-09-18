import 'package:banking_app/features/account/states/account_and_card_state.dart';
import 'package:banking_app/features/home/repositories/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountAndCardCubit extends Cubit<AccountAndCardState> {
  AccountAndCardCubit({required this.repo})
    : super(const AccountAndCardState());

  final HomeRepository repo;

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
}
