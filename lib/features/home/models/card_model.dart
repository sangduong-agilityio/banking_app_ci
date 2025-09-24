import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_model.freezed.dart';
part 'card_model.g.dart';

class CardTypeConverter implements JsonConverter<CardType?, String?> {
  const CardTypeConverter();

  @override
  CardType? fromJson(String? json) {
    if (json == null) return null;
    return CardType.values.firstWhere(
      (e) => e.name.toLowerCase() == json.toLowerCase(),
      orElse: () => CardType.discover,
    );
  }

  @override
  String? toJson(CardType? object) => object?.name;
}

@freezed
class CardModel with _$CardModel {
  const factory CardModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'card_number') required String cardNumber,
    @JsonKey(name: 'card_holder_name') required String cardHolderName,
    @JsonKey(name: 'card_tier') required String cardTier,
    @CardTypeConverter() @JsonKey(name: 'card_type') CardType? cardType,
    @JsonKey(name: 'valid_from') String? validFrom,
    @JsonKey(name: 'good_thru') String? goodThru,
    @JsonKey(name: 'available_balance') double? availableBalance,
    @JsonKey(name: 'bank_id') required String bankId,
  }) = _CardModel;

  factory CardModel.fromJson(Map<String, dynamic> json) =>
      _$CardModelFromJson(json);
}

enum CardType {
  visa,
  mastercard,
  discover;

  String get displayName {
    switch (this) {
      case CardType.visa:
        return 'Visa';
      case CardType.mastercard:
        return 'MasterCard';
      case CardType.discover:
        return 'Discover';
    }
  }

  Gradient get gradient {
    switch (this) {
      case CardType.visa:
        return const LinearGradient(
          colors: [
            Color(0xFF4A5568),
            Color(0xFF2D3748),
            Color(0xFF4299E1),
            Color(0xFF48BB78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case CardType.mastercard:
        return const LinearGradient(
          colors: [
            Color(0xFF667EEA),
            Color(0xFF764BA2),
            Color(0xFFED4264),
            Color(0xFFFFEDBC),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case CardType.discover:
        return const LinearGradient(
          colors: [
            Color(0xFFFDC830),
            Color(0xFFF37335),
            Color(0xFFFF8A80),
            Color(0xFFFFAB40),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}
