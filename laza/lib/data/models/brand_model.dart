import 'package:json/json.dart';
import 'package:laza/data/models/product_model.dart';

@JsonCodable()
class Brand {
  int? id;
  String? name;
  String? logo;
  String image;
  List<Product> products;
}
