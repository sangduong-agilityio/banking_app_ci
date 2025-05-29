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

  final List<ProductModel>? products;
  final BrowseStatus status;
  final String? errorMessage;

  BrowseState copyWith({
    List<ProductModel>? products,
    BrowseStatus? status,
    String? errorMessage,
  }) {
    return BrowseState(
      products: products ?? this.products,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        products,
        status,
        errorMessage,
      ];
}

@freezed
sealed class BrowseStatus with _$BrowseStatus {
  const factory BrowseStatus.initial() = BrowseStatusInitial;
  const factory BrowseStatus.loading() = BrowseStatusLoading;
  const factory BrowseStatus.success() = BrowseStatusSuccess;
  const factory BrowseStatus.failure() = BrowseStatusFailure;
}
