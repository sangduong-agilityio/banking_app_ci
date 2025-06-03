import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/features/home/models/product_model.dart';
import 'package:tradly_app/features/browse/repositories/browse_repo.dart';
import 'package:tradly_app/features/browse/states/browse_event.dart';
import 'package:tradly_app/features/browse/states/browse_state.dart';

class BrowseBloc extends Bloc<BrowseEvt, BrowseState> {
  BrowseBloc({
    required BrowseRepository repo,
  })  : _repo = repo,
        super(const BrowseState()) {
    on<BrowseInitializeEvt>(_onInitialize);
    on<BrowseSearchEvt>(_onSearchProduct);
    on<BrowseSortEvt>(_onSortProduct);
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
      emit(
        state.copyWith(
          status: const BrowseStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSearchProduct(
    BrowseSearchEvt event,
    Emitter<BrowseState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const BrowseStatus.loading(),
      ),
    );

    try {
      List<ProductModel> allProducts = state.products ?? [];

      if (event.query.isEmpty) {
        allProducts = await _repo.fetchProducts();
        emit(state.copyWith(
          products: allProducts,
          status: const BrowseStatus.success(),
        ));
        return;
      }

      final String query = event.query.toLowerCase();

      final List<ProductModel> searchProducts = allProducts
          .where((product) =>
              product.title.toLowerCase().contains(query) ||
              product.price.toLowerCase().contains(query))
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

  Future<void> _onSortProduct(
    BrowseSortEvt event,
    Emitter<BrowseState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const BrowseStatus.loading(),
      ),
    );

    try {
      List<ProductModel> products = state.products ?? [];

      if (products.isEmpty) {
        products = await _repo.fetchProducts();
      }

      final List<ProductModel> sortedProducts = List.from(products);

      if (event.sort == SortOrder.lowToHigh) {
        sortedProducts.sort(
          (a, b) => double.parse(a.price).compareTo(
            double.parse(b.price),
          ),
        );
      } else if (event.sort == SortOrder.highToLow) {
        sortedProducts.sort(
          (a, b) => double.parse(b.price).compareTo(
            double.parse(a.price),
          ),
        );
      }
      emit(
        state.copyWith(
          products: sortedProducts,
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
}
