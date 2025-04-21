import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/data/models/product_model.dart';
import 'package:tradly_app/data/repositories/store_repo.dart.dart';
import 'store_event.dart';
import 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc({required StoreRepository repo})
      : _repo = repo,
        super(const StoreState()) {
    on<StoreInitializeEvt>(_onInitialize);
    on<CreateStoreEvent>(_onCreateStore);
    on<AddProductEvent>(_onAddProduct);
    on<EditProductEvent>(_onEditProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }
  final StoreRepository _repo;

  Future<void> _onInitialize(
    StoreInitializeEvt event,
    Emitter<StoreState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const StoreStatus.loading(),
      ),
    );
    try {
      final hasStore = await _repo.hasStore();
      final products = hasStore
          ? (await _repo.getProducts()).cast<ProductModel>()
          : <ProductModel>[];
      emit(
        state.copyWith(
          hasStore: hasStore,
          products: products,
          status: const StoreStatus.success(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const StoreStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCreateStore(
    CreateStoreEvent event,
    Emitter<StoreState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const StoreStatus.loading(),
      ),
    );
    try {
      await _repo.createStore(
        event.storeName,
        event.description,
      );
      emit(
        state.copyWith(
          hasStore: true,
          status: const StoreStatus.success(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const StoreStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddProduct(
    AddProductEvent event,
    Emitter<StoreState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const StoreStatus.loading(),
      ),
    );
    try {
      await _repo.addProduct(event.product);
      final updatedProducts = List<ProductModel>.from(state.products ?? [])
        ..add(event.product);
      emit(
        state.copyWith(
          products: updatedProducts,
          status: const StoreStatus.success(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const StoreStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onEditProduct(
    EditProductEvent event,
    Emitter<StoreState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const StoreStatus.loading(),
      ),
    );
    try {
      await _repo.editProduct(event.product);
      final updatedProducts = state.products?.map(
        (product) {
          return product.id == event.product.id ? event.product : product;
        },
      ).toList();
      emit(
        state.copyWith(
          products: updatedProducts,
          status: const StoreStatus.success(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const StoreStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<StoreState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const StoreStatus.loading(),
      ),
    );
    try {
      await _repo.deleteProduct(event.productId);
      final updatedProducts = state.products
          ?.where((product) => product.id != event.productId)
          .toList();
      emit(
        state.copyWith(
          products: updatedProducts,
          status: const StoreStatus.success(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const StoreStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
