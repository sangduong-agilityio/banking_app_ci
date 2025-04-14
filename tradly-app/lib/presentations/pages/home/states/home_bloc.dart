import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/data/repositories/home_repo.dart';
import 'package:tradly_app/presentations/pages/home/states/home_event.dart';
import 'package:tradly_app/presentations/pages/home/states/home_state.dart';

class HomeBloc extends Bloc<HomeEvt, HomeState> {
  HomeBloc({
    required HomeRepository repo,
  })  : _repo = repo,
        super(const HomeState()) {
    on<HomeInitializeEvt>(_onInitializeHandler);
  }

  final HomeRepository _repo;

  Future<void> _onInitializeHandler(
    HomeInitializeEvt event,
    Emitter<HomeState> emit,
  ) async {
    await Future.wait<void>(
      [
        _fetchCategories(emit),
        _fetchProducts(emit),
      ],
    );
  }

  Future<void> _fetchCategories(Emitter<HomeState> emit) async {
    emit(
      state.copyWith(
        status: const HomeStatus.loading(),
      ),
    );
    try {
      final categories = await _repo.fetchCategories();
      emit(
        state.copyWith(
          categories: categories,
          status: const HomeStatus.success(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(
          status: const HomeStatus.failure(), errorMessage: e.toString()));
    }
  }

  Future<void> _fetchProducts(Emitter<HomeState> emit) async {
    emit(
      state.copyWith(
        status: const HomeStatus.loading(),
      ),
    );
    try {
      final products = await _repo.fetchProductsWithTypes();
      emit(
        state.copyWith(
          products: products,
          status: const HomeStatus.success(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(
          status: const HomeStatus.failure(), errorMessage: e.toString()));
    }
  }
}
