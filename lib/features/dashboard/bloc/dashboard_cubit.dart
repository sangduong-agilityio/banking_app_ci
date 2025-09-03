import 'package:banking_app/features/dashboard/bloc/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:banking_app/features/dashboard/services/dashboard_repository.dart';

class DashBoardCubit extends Cubit<DashBoardState> {
  DashBoardCubit({required this.repo}) : super(const DashBoardState());

  final DashboardRepository repo;

  Future<void> fetchDashboardData() async {
    emit(state.copyWith(status: const DashBoardStatus.loading()));
    try {
      final user = await repo.fetchCurrentUser();
      final cards = await repo.fetchCards();

      emit(
        state.copyWith(
          user: user,
          cards: cards,
          status: const DashBoardStatus.success(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const DashBoardStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
