import 'package:laza/data/models/model.dart';

@Model()
class Users {
  final String id;
  final String userName;
  final String displayName;
  final String avatar;
  final String review;
  Users({
    required this.id,
    required this.userName,
    required this.displayName,
    required this.avatar,
    required this.review,
  });
}
