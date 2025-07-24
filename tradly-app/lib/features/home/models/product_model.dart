import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductType with _$ProductType {
  const factory ProductType({
    required int id,
    required int productId,
    required String tag,
  }) = _ProductType;

  factory ProductType.fromJson(Map<String, dynamic> json) =>
      _$ProductTypeFromJson(json);
}

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    int? id,
    required String title,
    required String imageUrl,
    required String price,
    String? brand,
    String? newPrice,
    String? description,
    String? priceType,
    String? condition,
    String? location,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? categoryType,
    List<String>? addtionalDetail,
    int? categoryId,
    int? storeId,
    List<ProductType>? productType,
    @Default(false) bool isWishListed,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
