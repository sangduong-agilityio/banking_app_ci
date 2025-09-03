import 'package:flutter/material.dart';

class CardModel {
  final String id;
  final String userId;
  final String cardNumber;
  final String cardHolderName;
  final String balance;
  final String cardTier;
  final CardType cardType;

  CardModel({
    required this.id,
    required this.userId,
    required this.cardNumber,
    required this.cardHolderName,
    required this.balance,
    required this.cardType,
    required this.cardTier,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: (json['id'] ?? '') as String,
      userId: (json['user_id'] ?? '') as String,
      cardNumber: (json['card_number'] ?? '') as String,
      cardHolderName: (json['card_holder_name'] ?? '') as String,
      cardTier: (json['card_tier'] ?? '') as String,
      balance: json['balance']?.toString() ?? '0.00',
      cardType: CardType.values.firstWhere(
        (e) => e.name == (json['card_type'] ?? 'visa'),
        orElse: () => CardType.visa,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'card_number': cardNumber,
      'card_holder_name': cardHolderName,
      'card_tier': cardTier,
      'balance': balance,
      'card_type': cardType.name,
    };
  }
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

  List<Color> get gradientColors {
    switch (this) {
      case CardType.visa:
        return [
          Color(0xFFFFFFFF),
          Color(0xFF1573FF),
          Color(0xFF1E1671),
          Color(0xFF4EB4FF),
        ];
      case CardType.mastercard:
        return [
          Color(0xFFFDC830),
          Color(0xFFF37335),
          Color(0xFFFF8A80),
          Color(0xFFFFAB40),
        ];
      case CardType.discover:
        return [
          Color(0xFF667EEA),
          Color(0xFF764BA2),
          Color(0xFFED4264),
          Color(0xFFFFEDBC),
        ];
    }
  }
}
