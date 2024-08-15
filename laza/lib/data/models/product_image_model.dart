import 'package:laza/data/models/model.dart';

@Model()
class ProductImage {
  final int id;
  final String imageUrl;
  final int productId;

  ProductImage({
    required this.id,
    required this.imageUrl,
    required this.productId,
  });
}
