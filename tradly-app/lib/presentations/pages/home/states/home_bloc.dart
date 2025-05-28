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
    emit(
      state.copyWith(
        status: const HomeStatus.loading(),
      ),
    );
    try {
      await Future.wait<void>(
        [
          _onFetchCategories(emit),
          _onFetchNewProducts(emit),
          _onFetchPopularProducts(emit),
          _onFetchStores(emit),
        ],
      );
      emit(
        state.copyWith(
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

  Future<void> _onFetchCategories(
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
          categories: categories,
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

  Future<void> _onFetchStores(
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const HomeStatus.loading(),
      ),
    );
    try {
      final stores = await _repo.fetchStores();
      emit(
        state.copyWith(
          stores: stores,
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

  Future<void> _onFetchNewProducts(
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const HomeStatus.loading(),
      ),
    );
    try {
      final newProducts = await _repo.fetchNewProducts();
      emit(
        state.copyWith(
          newProducts: newProducts,
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

  Future<void> _onFetchPopularProducts(
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const HomeStatus.loading(),
      ),
    );
    try {
      final popularProducts = await _repo.fetchPopularProducts();
      emit(
        state.copyWith(
          popularProducts: popularProducts,
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
}
