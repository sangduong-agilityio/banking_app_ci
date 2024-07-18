import 'package:json/json.dart';

@JsonCodable()
class User {
  final int? id;
  final String username;
  final String displayName;
  final String avatar;
}
