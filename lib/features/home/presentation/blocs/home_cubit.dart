import 'package:banking_app/features/home/presentation/blocs/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:banking_app/features/home/data/repositories/home_repository.dart';

/// A Cubit that manages the state of the home screen.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.repo}) : super(const HomeState());

  /// The repository for fetching home screen data.
  final HomeRepository repo;

  /// Initializes the home screen by fetching the user and card data.
  Future<void> homeInitialize() async {
    emit(state.copyWith(status:  HomeStatus.loading));
    try {
      final user = await repo.fetchCurrentUser();
      final cards = await repo.fetchCards();

      emit(
        state.copyWith(
          user: user,
          cards: cards,
          status:  HomeStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status:  HomeStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Changes the index of the currently selected card.
  void changeCardIndex(int index) {
    emit(state.copyWith(currentCardIndex: index));
  }

  /// Sets the animation status for the card swiper.
  void setAnimationStatus(bool value) {
    emit(state.copyWith(shouldPlayAnimation: value));
  }

  void toggleBalanceVisibility() {
    emit(state.copyWith(isBalanceVisible: !state.isBalanceVisible));
  }
}
