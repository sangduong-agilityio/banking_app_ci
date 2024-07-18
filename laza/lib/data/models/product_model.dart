import 'package:json/json.dart';
import 'package:laza/data/models/brand_model.dart';

@JsonCodable()
class Product {
  final int? id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final Brand brand;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.brand,
  });
}
