import 'package:json/json.dart';
import 'package:laza/data/models/brand_model.dart';

@JsonCodable()
class Product {
  int? id;
  String name;
  double price;
  String imageUrl;
  String description;
  Brand brand;
}
