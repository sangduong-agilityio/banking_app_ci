import 'package:banking_app/features/home/states/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:banking_app/features/home/repositories/home_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.repo}) : super(const HomeState());

  final HomeRepository repo;

  Future<void> homeInitialize() async {
    emit(state.copyWith(status: const HomeStatus.loading()));
    try {
      final user = await repo.fetchCurrentUser();
      final cards = await repo.fetchCards();

      emit(
        state.copyWith(
          user: user,
          cards: cards,
          status: const HomeStatus.success(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const HomeStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> changeCardIndex(int index) async {
    emit(state.copyWith(currentCardIndex: index));
  }

  Future<void> setAnimationStatus(bool value) async {
    emit(state.copyWith(shouldPlayAnimation: value));
  }
}
