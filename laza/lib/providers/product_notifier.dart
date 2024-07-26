import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laza/data/models/product_model.dart';
import 'package:laza/providers/product_provider.dart';
import 'package:laza/services/product_service.dart';

abstract class BaseProductsNotifier
    extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductService _productService;

  BaseProductsNotifier(this._productService)
      : super(const AsyncValue.loading());

  Future<void> fetchAndSetProducts(
      Future<List<Product>> Function() fetchFunction) async {
    try {
      final products = await fetchFunction();
      state = AsyncValue.data(products);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

class ProductsNotifier extends BaseProductsNotifier {
  ProductsNotifier(super.productService) {
    fetchAndSetProducts(_productService.getProducts);
  }
}

final productsProvider =
    StateNotifierProvider<ProductsNotifier, AsyncValue<List<Product>>>((ref) {
  return ProductsNotifier(ref.watch(productServiceProvider));
});

class SearchProductsNotifier extends BaseProductsNotifier {
  SearchProductsNotifier(super.productService);

  Future<void> searchProducts(String query) async {
    await fetchAndSetProducts(() => _productService.searchProducts(query));
  }
}

final searchProductsProvider = StateNotifierProvider.family<
    SearchProductsNotifier, AsyncValue<List<Product>>, String>((ref, query) {
  return SearchProductsNotifier(ref.watch(productServiceProvider))
    ..searchProducts(query);
});
