import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_model.freezed.dart';
part 'contact_model.g.dart';

@freezed
class ContactModel with _$ContactModel {
  const factory ContactModel({
    required String id,
    required String userId,
    required String name,
    String? email,
    String? phoneNumber,
    String? accountNumber,
    String? imageUrl,
    String? amount,
    required bool isFavorite,
    required DateTime createdAt,
  }) = _ContactModel;

  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);
}
