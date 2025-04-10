import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/data/repositories/category_repo.dart';
import 'package:tradly_app/presentations/pages/home/states/home_event.dart';
import 'package:tradly_app/presentations/pages/home/states/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required this.repository,
  }) : super(HomeInitialState()) {
    on<HomeFetchAllEvent>(_fetchAll);
  }

  final CategoryRepository repository;

  Future<void> _fetchAll(
    HomeFetchAllEvent event,
    Emitter<HomeState> emit,
  ) async {
    await Future.wait<void>([
      _fetchCategories(emit),
    ]);
  }

  Future<void> _fetchCategories(
    Emitter<HomeState> emit,
  ) async {
    emit(
      const HomeCategoryState(isLoading: true),
    );
    try {
      final categories = await repository.fetchCategories();
      emit(
        HomeCategoryState(
          courseCategories: categories,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        HomeCategoryState(
          error: e.toString(),
        ),
      );
    }
  }
}
