import 'package:laza/data/models/model.dart';

@Model()
class User {
  final int id;
  final String username;
  final String displayName;
  final String avatar;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatar,
  });
}
