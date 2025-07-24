import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tradly_app/features/home/models/product_model.dart';

part 'store_model.freezed.dart';
part 'store_model.g.dart';

@freezed
class StoreModel with _$StoreModel {
  const factory StoreModel({
    int? id,
    required String storeName,
    String? storeWebAddress,
    String? storeDescription,
    String? storeType,
    String? imageUrl,
    String? address,
    String? city,
    String? logoStore,
    String? country,
    String? courieName,
    List<String>? tagLine,
    List<ProductModel>? products,
    DateTime? startDate,
  }) = _StoreModel;

  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);
}
