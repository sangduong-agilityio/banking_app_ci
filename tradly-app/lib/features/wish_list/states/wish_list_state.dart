import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tradly_app/features/home/models/product_model.dart';

part 'wish_list_state.freezed.dart';

class WishListState extends Equatable {
  const WishListState({
    this.wishlist = const [],
    this.status = const WishListStatus.initial(),
    this.errorMessage,
  });

  final List<ProductModel> wishlist;
  final WishListStatus status;
  final String? errorMessage;

  WishListState copyWith({
    List<ProductModel>? wishlist,
    WishListStatus? status,
    String? errorMessage,
  }) {
    return WishListState(
      wishlist: wishlist ?? this.wishlist,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        wishlist,
        status,
        errorMessage,
      ];
}

@freezed
sealed class WishListStatus with _$WishListStatus {
  const factory WishListStatus.initial() = WishListStatusInitial;
  const factory WishListStatus.loading() = WishListStatusLoading;
  const factory WishListStatus.success() = WishListStatusSuccess;
  const factory WishListStatus.failure() = WishListStatusFailure;
}
