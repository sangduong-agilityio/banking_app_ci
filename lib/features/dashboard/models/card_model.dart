import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'card_model.freezed.dart';
part 'card_model.g.dart';

@freezed
class CardModel with _$CardModel {
  const factory CardModel({
    required String id,
    required String userId,
    required String cardNumber,
    required String cardHolderName,
    required String expiryMonth,
    required String expiryYear,
    String? cvv,
    required CardType cardType,
    @Default(false) bool isDefault,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CardModel;

  factory CardModel.fromJson(Map<String, dynamic> json) =>
      _$CardModelFromJson(json);
}

enum CardType {
  visa,
  mastercard,
  amex,
  discover;

  String get displayName {
    switch (this) {
      case CardType.visa:
        return 'Visa';
      case CardType.mastercard:
        return 'MasterCard';
      case CardType.amex:
        return 'American Express';
      case CardType.discover:
        return 'Discover';
    }
  }

  String get logoPath {
    switch (this) {
      case CardType.visa:
        return 'assets/images/visa_logo.png';
      case CardType.mastercard:
        return 'assets/images/mastercard_logo.png';
      case CardType.amex:
        return 'assets/images/amex_logo.png';
      case CardType.discover:
        return 'assets/images/discover_logo.png';
    }
  }

  Color get primaryColor {
    switch (this) {
      case CardType.visa:
        return const Color(0xFF1A1F71);
      case CardType.mastercard:
        return const Color(0xFFEB001B);
      case CardType.amex:
        return const Color(0xFF006FCF);
      case CardType.discover:
        return const Color(0xFFFF6000);
    }
  }

  List<Color> get gradientColors {
    switch (this) {
      case CardType.visa:
        return [const Color(0xFF1A1F71), const Color(0xFF4A90E2)];
      case CardType.mastercard:
        return [const Color(0xFFEB001B), const Color(0xFFF79E1B)];
      case CardType.amex:
        return [const Color(0xFF006FCF), const Color(0xFF00A9E0)];
      case CardType.discover:
        return [const Color(0xFFFF6000), const Color(0xFFFFB366)];
    }
  }
}
