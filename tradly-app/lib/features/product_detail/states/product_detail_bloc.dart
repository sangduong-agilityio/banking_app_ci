import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/features/product_detail/repositories/product_repo.dart';
import 'package:tradly_app/features/product_detail/states/product_detail_event.dart';
import 'package:tradly_app/features/product_detail/states/product_detail_state.dart';
import 'package:tradly_app/utils/permission_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvt, ProductDetailState> {
  ProductDetailBloc({
    required ProductRepository repo,
  })  : _repo = repo,
        super(const ProductDetailState()) {
    on<ProductDetailInitializeEvt>(_onInitialize);
    on<ProductDetailFetchEvt>(_onFetchProductDetail);
    on<ProductDetailFormValidateChangedEvt>(_onFormValidateChanged);
    on<ProductDetailGetCurrentLocationEvt>(_onGetCurrentLocation);
    on<ProductDetailAddAddressEvt>(_onAddAddress);
    on<ProductDetailCheckoutEvt>(_onCheckout);
    on<ProductDetailToggleWishListEvt>(_onToggleWishList);
  }

  final ProductRepository _repo;

  Future<void> _onInitialize(
    ProductDetailInitializeEvt event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const ProductDetailStatus.loading(),
      ),
    );

    try {
      final products = await _repo.fetchProductsByCategoryId(
        event.categoryId,
      );
      emit(
        state.copyWith(
          products: products,
          status: const ProductDetailStatus.success(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(
          status: const ProductDetailStatus.failure(),
          errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchProductDetail(
    ProductDetailFetchEvt event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const ProductDetailStatus.loading(),
      ),
    );

    try {
      final product = (await _repo.fetchProductById(event.productId)).first;
      emit(
        state.copyWith(
          product: product,
          status: const ProductDetailStatus.success(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const ProductDetailStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onGetCurrentLocation(
    ProductDetailGetCurrentLocationEvt event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const ProductDetailStatus.loading(),
      ),
    );

    try {
      final position = await PermissionHelper.getCurrentLocation();
      final address = await PermissionHelper.getAddressFromPosition(position);
      emit(
        state.copyWith(
          hasAddress: true,
          product: address,
          status: const ProductDetailStatus.success(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const ProductDetailStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddAddress(
    ProductDetailAddAddressEvt event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const ProductDetailStatus.loading(),
      ),
    );

    try {
      emit(
        state.copyWith(
          product: event.product,
          status: const ProductDetailStatus.success(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const ProductDetailStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onFormValidateChanged(
    ProductDetailFormValidateChangedEvt event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        isFormValid: event.isValidate,
        product: event.product,
      ),
    );
  }

  Future<void> _onCheckout(
    ProductDetailCheckoutEvt event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const ProductDetailStatus.loading(),
      ),
    );

    try {
      final supabase = Supabase.instance.client;
      final orderData = {
        'title': event.product.title,
        'price': event.product.price,
        'newPrice': event.product.newPrice,
        'imageUrl': event.product.imageUrl,
        'address':
            '${event.product.street}, ${event.product.city}, ${event.product.state}, ${event.product.zipCode}',
      };
      await supabase.from('orders').insert(orderData);

      emit(
        state.copyWith(
          product: event.product,
          status: const ProductDetailStatus.success(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const ProductDetailStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onToggleWishList(
    ProductDetailToggleWishListEvt event,
    Emitter<ProductDetailState> emit,
  ) async {
    final currentProduct = state.product;
    if (currentProduct != null) {
      final updatedProduct = currentProduct.copyWith(
        isWishListed: !currentProduct.isWishListed,
      );
      emit(state.copyWith(product: updatedProduct));
    }
  }
}
