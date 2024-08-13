import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laza/data/models/product_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@Riverpod(keepAlive: true)
class ProductListNotifier extends StateNotifier<List<Product>> {
  ProductListNotifier() : super([]);

  void addProduct(Product product) {
    state = [...state, product];
  }

  void removeProduct(Product product) {
    state = state.where((p) => p.id != product.id).toList();
  }

  int get totalProducts => state.length;
}

final wishListProvider =
    StateNotifierProvider<ProductListNotifier, List<Product>>((ref) {
  return ProductListNotifier();
});

final cartProvider =
    StateNotifierProvider<ProductListNotifier, List<Product>>((ref) {
  return ProductListNotifier();
});
