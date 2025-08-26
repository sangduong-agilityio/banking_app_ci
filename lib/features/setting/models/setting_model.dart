import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_model.freezed.dart';
part 'setting_model.g.dart';

@freezed
class SettingModel with _$SettingModel {
  const factory SettingModel({
    required String id,
    required String email,
    String? fullName,
    String? phoneNumber,
    String? accountNumber,
    String? homeAddress,
    String? profileImage,
    required double balance,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SettingModel;

  factory SettingModel.fromJson(Map<String, dynamic> json) =>
      _$SettingModelFromJson(json);
}
