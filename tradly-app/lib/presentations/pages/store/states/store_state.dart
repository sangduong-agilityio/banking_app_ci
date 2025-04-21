import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tradly_app/data/models/product_model.dart';
import 'package:tradly_app/data/models/store_model.dart';

part 'store_state.freezed.dart';

class StoreState extends Equatable {
  const StoreState({
    this.hasStore = false,
    this.products,
    this.stores,
    this.status = const StoreStatus.initial(),
    this.errorMessage,
  });

  final bool hasStore;
  final List<ProductModel>? products;
  final List<StoreModel>? stores;
  final StoreStatus status;
  final String? errorMessage;

  StoreState copyWith({
    bool? hasStore,
    List<ProductModel>? products,
    List<StoreModel>? stores,
    StoreStatus? status,
    String? errorMessage,
  }) {
    return StoreState(
      hasStore: hasStore ?? this.hasStore,
      products: products ?? this.products,
      stores: stores ?? this.stores,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        hasStore,
        products,
        status,
        errorMessage,
        stores,
      ];
}

@freezed
sealed class StoreStatus with _$StoreStatus {
  const factory StoreStatus.initial() = StorelStatusInitial;
  const factory StoreStatus.loading() = StorelStatusLoading;
  const factory StoreStatus.success() = StorelStatusSuccess;
  const factory StoreStatus.failure() = StorelStatusFailure;
}
