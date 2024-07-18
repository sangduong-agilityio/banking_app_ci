import 'package:json/json.dart';
import 'package:laza/data/models/product_model.dart';

@JsonCodable()
class Brand {
  final int? id;
  final String name;
  final String image;
  final List<Product> products;

  Brand({
    this.id,
    required this.name,
    required this.image,
    this.products = const [],
  });
}
