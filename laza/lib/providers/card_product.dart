import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laza/data/models/product_model.dart';

class CardProductNotifier extends StateNotifier<List<Product>> {
  CardProductNotifier() : super([]);

  void addProduct(Product product) {
    state = [...state, product];
  }

  void removeProduct(Product product) {
    state = state.where((p) => p.id != product.id).toList();
  }

  int get totalProducts => state.length;
}

final wishListProvider =
    StateNotifierProvider<CardProductNotifier, List<Product>>((ref) {
  return CardProductNotifier();
});

final cartProvider =
    StateNotifierProvider<CardProductNotifier, List<Product>>((ref) {
  return CardProductNotifier();
});
