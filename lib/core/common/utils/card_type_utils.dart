import 'package:banking_app/features/home/data/models/card_model.dart';
import 'package:flutter/material.dart';

class CardTypeUtils {
  /// Returns the display name for each card type.
  static String getDisplayName(CardType type) {
    switch (type) {
      case CardType.visa:
        return 'Visa';
      case CardType.mastercard:
        return 'MasterCard';
      case CardType.discover:
        return 'Discover';
    }
  }

  /// Returns the gradient background style for each card type.
  static Gradient getGradient(CardType type) {
    switch (type) {
      case CardType.visa:
        // Visa: Blue & Gray tones - professional and trusted look
        return const LinearGradient(
          colors: [
            Color(0xFF1A365D),
            Color(0xFF2C5282),
            Color(0xFF3182CE),
            Color(0xFF4299E1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

      case CardType.mastercard:
        // MasterCard: Red & Orange gradient - bold and dynamic
        return const LinearGradient(
          colors: [
            Color(0xFF7B1FA2),
            Color(0xFFE91E63),
            Color(0xFFFF5722),
            Color(0xFFFFAB40),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

      case CardType.discover:
        // Discover: Orange & Yellow tones - vibrant and energetic
        return const LinearGradient(
          colors: [
            Color(0xFFEF6C00),
            Color(0xFFFF8A65),
            Color(0xFFFFB74D),
            Color(0xFFFFD54F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  /// Returns the primary color for each card type (used for icons, accents, etc.)
  static Color getPrimaryColor(CardType type) {
    switch (type) {
      case CardType.visa:
        return const Color(0xFF3182CE);
      case CardType.mastercard:
        return const Color(0xFFE91E63);
      case CardType.discover:
        return const Color(0xFFFF8A65);
    }
  }

  /// Returns the secondary color for each card type.
  static Color getSecondaryColor(CardType type) {
    switch (type) {
      case CardType.visa:
        return const Color(0xFF4299E1);
      case CardType.mastercard:
        return const Color(0xFFFF5722);
      case CardType.discover:
        return const Color(0xFFFFD54F);
    }
  }

  /// Returns the text style for displaying the card name.
  static TextStyle getDisplayNameStyle(CardType type) {
    switch (type) {
      case CardType.visa:
        return const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          fontStyle: FontStyle.normal,
        );

      case CardType.mastercard:
        return const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          letterSpacing: 0.5,
        );

      case CardType.discover:
        return const TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
        );
    }
  }

  /// Returns a shadow color with opacity based on the card type.
  static Color getShadowColor(CardType type) {
    switch (type) {
      case CardType.visa:
        return const Color(0xFF3182CE).withAlpha(50);
      case CardType.mastercard:
        return const Color(0xFFE91E63).withAlpha(50);
      case CardType.discover:
        return const Color(0xFFFF8A65).withAlpha(50);
    }
  }

  /// Returns the icon for visibility toggle, can be customized per card type.
  static IconData getVisibilityIcon(CardType type, bool isVisible) {
    return isVisible ? Icons.visibility : Icons.visibility_off;
  }

  /// Returns the border radius for each card type to define shape style.
  static double getBorderRadius(CardType type) {
    switch (type) {
      case CardType.visa:
        return 20.0; // Sharper corners - professional look
      case CardType.mastercard:
        return 24.0; // More rounded - modern look
      case CardType.discover:
        return 22.0; // Medium rounded
    }
  }
}
