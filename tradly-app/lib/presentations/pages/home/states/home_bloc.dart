import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/data/repositories/category_repo.dart';
import 'package:tradly_app/presentations/pages/home/states/home_event.dart';
import 'package:tradly_app/presentations/pages/home/states/home_state.dart';

class HomeBloc extends Bloc<HomeEvt, HomeState> {
  HomeBloc({
    required CategoryRepository repo,
  })  : _repo = repo,
        super(const HomeState()) {
    on<HomeInitializeEvt>(_onInitializeHandler);
  }

  final CategoryRepository _repo;

  Future<void> _onInitializeHandler(
    HomeInitializeEvt event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const HomeStatus.loading(),
      ),
    );

    try {
      final categories = await _repo.fetchCategories();
      emit(
        state.copyWith(
          status: const HomeStatus.success(),
          categories: categories,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: const HomeStatus.failure(),
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
