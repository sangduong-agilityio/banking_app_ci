import 'package:json/json.dart';
import 'package:laza/data/models/brand_model.dart';
import 'package:laza/data/models/product_model.dart';

@JsonCodable()
class User {
  final int? id;
  final String username;
  final String displayName;
  final String avatar;
  final List<Product> wishlist;
  final List<Brand> favoriteBrands;

  User({
    this.id,
    required this.username,
    required this.displayName,
    required this.avatar,
    this.wishlist = const [],
    this.favoriteBrands = const [],
  });
}
