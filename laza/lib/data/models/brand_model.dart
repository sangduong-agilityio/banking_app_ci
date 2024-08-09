import 'package:laza/data/models/md.dart';

@Model()
class Brand {
  final int id;
  final String name;
  final String image;
  Brand({
    required this.id,
    required this.name,
    required this.image,
  });
}
