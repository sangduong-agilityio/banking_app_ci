import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/features/home/models/product_model.dart';
import 'package:tradly_app/features/wish_list/states/wish_list_state.dart';

class WishListCubit extends Cubit<WishListState> {
  WishListCubit() : super(const WishListState());

  final List<ProductModel> wishList = [];

  void fetchWishList() {
    emit(
      state.copyWith(
        wishlist: List.unmodifiable(wishList),
        status: const WishListStatus.success(),
      ),
    );
  }

  void addToWishList(ProductModel product) {
    wishList.add(product);
    emit(
      state.copyWith(
        wishlist: List.unmodifiable(wishList),
        status: const WishListStatus.success(),
      ),
    );
  }

  void removeFromWishList(ProductModel product) {
    wishList.remove(product);
    emit(
      state.copyWith(
        wishlist: List.unmodifiable(wishList),
        status: const WishListStatus.success(),
      ),
    );
  }
}
