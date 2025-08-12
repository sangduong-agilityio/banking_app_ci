import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_model.freezed.dart';
part 'transfer_model.g.dart';

@freezed
class TransferModel with _$TransferModel {
  const factory TransferModel({
    required String id,
    required String userId,
    required PaymentMethodType type,
    required String name,
    String? lastFourDigits,
    CardType? cardType,
    required double balance,
    required bool isPrimary,
    required bool isActive,
    required DateTime createdAt,
  }) = _TransferModel;

  factory TransferModel.fromJson(Map<String, dynamic> json) =>
      _$TransferModelFromJson(json);
}

enum PaymentMethodType { card, bankAccount }

enum CardType { visa, mastercard, amex, discover }
