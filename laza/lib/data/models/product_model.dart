import 'package:json/json.dart';
import 'package:laza/data/models/brand_model.dart';

@JsonCodable()
class Product {
  final int? id;
  final String name;
  final double price;
  final String image;
  final String description;
  final Brand brand;
  final List<String> images;
  final List<String> sizes;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.brand,
    required this.images,
    required this.sizes,
  });
}
