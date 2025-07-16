import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tradly_app/features/home/models/product_model.dart';

part 'browse_state.freezed.dart';

final class BrowseState extends Equatable {
  const BrowseState({
    this.products,
    this.status = const BrowseStatus.initial(),
    this.errorMessage,
    this.hasMore = true,
    this.currentPage = 1,
  });

  final List<ProductModel>? products;
  final BrowseStatus status;
  final String? errorMessage;
  final bool hasMore;
  final int currentPage;

  BrowseState copyWith({
    List<ProductModel>? products,
    BrowseStatus? status,
    String? errorMessage,
    bool? hasMore,
    int? currentPage,
  }) {
    return BrowseState(
      products: products ?? this.products,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props =>
      [products, status, errorMessage, hasMore, currentPage];
}

@freezed
sealed class BrowseStatus with _$BrowseStatus {
  const factory BrowseStatus.initial() = BrowseStatusInitial;
  const factory BrowseStatus.loading() = BrowseStatusLoading;
  const factory BrowseStatus.success() = BrowseStatusSuccess;
  const factory BrowseStatus.failure() = BrowseStatusFailure;
}
