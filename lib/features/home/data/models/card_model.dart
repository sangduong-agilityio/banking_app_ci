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
    required String userId,
    required String cardNumber,
    required String cardHolderName,
    required String cardTier,
    required String currency,
    @Default(CardType.visa) CardType? cardType,
    String? validFrom,
    String? goodThru,
    double? availableBalance,
    required String bankId,
    @Default(CardStatus.active) CardStatus? status,
  }) = _CardModel;

  factory CardModel.fromJson(Map<String, dynamic> json) =>
      _$CardModelFromJson(json);
}

enum CardStatus { active, frozen, expired }

enum CardType {
  visa,
  mastercard,
  discover;
}
