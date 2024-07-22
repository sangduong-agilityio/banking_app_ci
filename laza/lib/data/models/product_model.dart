import 'package:laza/data/models/model.dart';

@Model()
class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;

  Product({
    required this.imageUrl,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });
}
