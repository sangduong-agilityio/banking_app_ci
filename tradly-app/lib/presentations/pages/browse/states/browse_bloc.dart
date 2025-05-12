import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/data/repositories/browse_repo.dart';
import 'package:tradly_app/presentations/pages/browse/states/browse_event.dart';
import 'package:tradly_app/presentations/pages/browse/states/browse_state.dart';

class BrowseBloc extends Bloc<BrowseEvt, BrowseState> {
  BrowseBloc({
    required BrowseRepository repo,
  })  : _repo = repo,
        super(const BrowseState()) {
    on<BrowseInitializeEvt>(_onInitialize);
    on<BrowseSearchEvt>(_onSearchHandler);
    on<BrowseSortEvt>(_onSortHandler);
  }

  final BrowseRepository _repo;

  Future<void> _onInitialize(
    BrowseInitializeEvt event,
    Emitter<BrowseState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const BrowseStatus.loading(),
      ),
    );
    try {
      final products = await _repo.fetchProducts();
      emit(
        state.copyWith(
          products: products,
          status: const BrowseStatus.success(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: const BrowseStatus.failure(),
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSearchHandler(
    BrowseSearchEvt event,
    Emitter<BrowseState> emit,
  ) async {
    try {
      final searchProducts = (state.products ?? [])
          .where((product) =>
              product.title.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(
        state.copyWith(
          products: searchProducts,
          status: const BrowseStatus.success(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const BrowseStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSortHandler(
    BrowseSortEvt event,
    Emitter<BrowseState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const BrowseStatus.loading(),
      ),
    );
    try {
      final sortedProducts = (state.products ?? [])
        ..sort((a, b) {
          if (event.sortBy == 'price') {
            return a.price.compareTo(b.price);
          } else if (event.sortBy == 'title') {
            return a.title.compareTo(b.title);
          }
          return 0;
        });
      emit(
        state.copyWith(
          products: sortedProducts,
          status: const BrowseStatus.success(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: const BrowseStatus.failure(),
        errorMessage: e.toString(),
      ));
    }
  }
}
