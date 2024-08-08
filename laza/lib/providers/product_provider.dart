import 'package:laza/core/api/api_client.dart';
import 'package:laza/core/env/env.dart';
import 'package:laza/data/models/product_model.dart';
import 'package:laza/data/repositories/product_repo.dart';
import 'package:laza/presentations/pages/brand_detail/widgets/sort_detail.dart';
import 'package:laza/services/product_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_provider.g.dart';

@Riverpod(keepAlive: true)
LazaApiClient lazaApiClient(LazaApiClientRef ref) {
  return LazaApiClient(baseUrl: Env.supabaseUrl);
}

@Riverpod(keepAlive: true)
ProductRepository productRepository(ProductRepositoryRef ref) {
  return ProductRepositoryImpl(apiClient: ref.watch(lazaApiClientProvider));
}

@Riverpod(keepAlive: true)
ProductService productService(ProductServiceRef ref) {
  return ProductService(
      productRepository: ref.watch(productRepositoryProvider));
}

@Riverpod(keepAlive: true)
class ProductsNotifier extends _$ProductsNotifier {
  late final ProductService _productService;

  List<Product> _products = [];
  int selectedImageIndex = -1;
  String selectedImageUrl = '';

  @override
  FutureOr<List<Product>> build(
    String query, {
    int? brandId,
    int? productId,
  }) async {
    _productService = ref.watch(productServiceProvider);
    _products = await _productService.getProducts(query,
        brandId: brandId, productId: productId);
    return _products;
  }

  void search(
    String query, {
    int? brandId,
    int? productId,
  }) async {
    final products = await _productService.getProducts(
      query,
      brandId: brandId,
      productId: productId,
    );
    state = AsyncValue.data(products);
  }

  void sortProducts(SortType sortType) {
    final products = state.valueOrNull ?? [];
    switch (sortType) {
      case SortType.priceLowToHigh:
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortType.priceHighToLow:
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
    }
    state = AsyncValue.data(products);
  }

  void selectImage(int index) {
    selectedImageIndex = index;
    selectedImageUrl = _products[index].imageUrl;
    state = AsyncValue.data(_products);
  }
}
