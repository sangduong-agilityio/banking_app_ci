import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tradly_app/features/home/models/product_model.dart';

part 'order_history_state.freezed.dart';

final class OrderHistoryState extends Equatable {
  const OrderHistoryState({
    this.products = const [],
    this.status = const OrderHistoryStatus.initial(),
  });

  final List<ProductModel> products;
  final OrderHistoryStatus status;

  OrderHistoryState copyWith({
    List<ProductModel>? products,
    OrderHistoryStatus? status,
  }) {
    return OrderHistoryState(
      products: products ?? this.products,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [products, status];
}

@freezed
sealed class OrderHistoryStatus with _$OrderHistoryStatus {
  const factory OrderHistoryStatus.initial() = OrderHistoryStatusInitial;
  const factory OrderHistoryStatus.loading() = OrderHistoryStatusLoading;
  const factory OrderHistoryStatus.success() = OrderHistoryStatusSuccess;
  const factory OrderHistoryStatus.failure() = OrderHistoryStatusFailure;
}
