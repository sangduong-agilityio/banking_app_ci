import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_model.freezed.dart';
part 'setting_model.g.dart';

@freezed
class SettingModel with _$SettingModel {
  const factory SettingModel({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? accountNumber,
    String? homeAddress,
    String? profileImage,
    double? balance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SettingModel;

  factory SettingModel.fromJson(Map<String, dynamic> json) =>
      _$SettingModelFromJson(json);
}
