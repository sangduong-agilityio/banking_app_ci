import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tradly_app/data/models/product_model.dart';

part 'browse_state.freezed.dart';

final class BrowseState extends Equatable {
  const BrowseState({
    this.products,
    this.status = const BrowseStatus.initial(),
    this.errorMessage,
  });
  final BrowseStatus status;
  final String? errorMessage;
  final List<ProductModel>? products;
  BrowseState copyWith({
    BrowseStatus? status,
    String? errorMessage,
    List<ProductModel>? products,
  }) {
    return BrowseState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      products: products ?? this.products,
    );
  }

  @override
  List<Object> get props => [
        status,
        errorMessage ?? '',
        products ?? [],
      ];
}

@freezed
sealed class BrowseStatus with _$BrowseStatus {
  const factory BrowseStatus.initial() = BrowseStatusInitial;
  const factory BrowseStatus.loading() = BrowseStatusLoading;
  const factory BrowseStatus.success() = BrowseStatusSuccess;
  const factory BrowseStatus.failure() = BrowseStatusFailure;
}
