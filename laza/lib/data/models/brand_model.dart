import 'package:json/json.dart';

@JsonCodable()
class Brand {
  final int? id;
  final String name;
  final String image;

  Brand({
    this.id,
    required this.name,
    required this.image,
  });
}
