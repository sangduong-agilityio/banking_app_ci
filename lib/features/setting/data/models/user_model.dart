import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    String? id,
    String? email,
    String? username,
    String? phoneNumber,
    String? accountNumber,
    String? homeAddress,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModelModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
