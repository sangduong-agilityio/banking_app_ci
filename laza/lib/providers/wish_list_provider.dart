import 'package:laza/data/models/product_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wish_list_provider.g.dart';

@Riverpod(keepAlive: true)
class WishListNotifier extends _$WishListNotifier {
  @override
  List<Product> build() {
    return [];
  }

  void addProduct(Product product) {
    state = [...state, product];
  }

  void removeProduct(Product product) {
    state = state.where((p) => p.id != product.id).toList();
  }
}
