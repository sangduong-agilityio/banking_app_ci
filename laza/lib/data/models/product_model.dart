import 'package:json/json.dart';
import 'package:laza/data/models/brand_model.dart';

@JsonCodable()
class Product {
  final int? id;
  final String? name;
  final String? description;
  final double? price;
  final String? imageUrl;
  final Brand? brand;
  final List<String>? images;
  final List<String>? sizes;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.brand,
    this.images,
    this.sizes,
  });
}
