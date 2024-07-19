import 'package:json/json.dart';
import 'package:laza/data/models/brand_model.dart';
import 'package:laza/data/models/product_model.dart';

@JsonCodable()
class User {
  int? id;
  String username;
  String displayName;
  String avatar;
  List<Product> wishlist;
  List<Brand> favoriteBrands;
}
