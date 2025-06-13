import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/features/home/models/product_model.dart';
import 'package:tradly_app/features/wish_list/states/wish_list_event.dart';
import 'package:tradly_app/features/wish_list/states/wish_list_state.dart';

class WishListBloc extends Bloc<WishListEvt, WishListState> {
  WishListBloc() : super(const WishListState()) {
    on<FetchWishListEvt>(_onFetchWishList);
    on<AddToWishListEvt>(_onAddToWishList);
    on<RemoveFromWishListEvent>(_onRemoveFromWishList);
  }

  final List<ProductModel> wishList = [];

  void _onFetchWishList(
    FetchWishListEvt event,
    Emitter<WishListState> emit,
  ) {
    emit(
      state.copyWith(
        wishlist: List.unmodifiable(wishList),
        status: const WishListStatus.success(),
      ),
    );
  }

  void _onAddToWishList(
    AddToWishListEvt event,
    Emitter<WishListState> emit,
  ) {
    wishList.add(event.product);
    emit(
      state.copyWith(
        wishlist: List.unmodifiable(wishList),
        status: const WishListStatus.success(),
      ),
    );
  }

  void _onRemoveFromWishList(
    RemoveFromWishListEvent event,
    Emitter<WishListState> emit,
  ) {
    wishList.remove(event.product);
    emit(
      state.copyWith(
        wishlist: List.unmodifiable(wishList),
        status: const WishListStatus.success(),
      ),
    );
  }
}
