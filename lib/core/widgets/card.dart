import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/app/themes/app_colors.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/common/utils/formatters.dart';
import 'package:banking_app/features/home/data/models/card_model.dart';
import 'package:banking_app/core/common/utils/card_type_utils.dart';
import 'package:flutter/material.dart';

/// A generic card widget that can be customized with different properties.
///
/// This widget can be used to create various card-based UI elements.
class BACard extends StatelessWidget {
  /// Creates a [BACard] widget.
  const BACard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
    this.gradient,
    this.width,
    this.height,
    this.showShadow = true,
    this.customBorderRadius,
  });

  /// The child widget to display inside the card.
  final Widget child;

  /// The callback that is called when the card is tapped.
  final VoidCallback? onTap;

  /// The padding of the card.
  final EdgeInsetsGeometry? padding;

  /// The margin of the card.
  final EdgeInsetsGeometry? margin;

  /// The border radius of the card.
  final double? borderRadius;

  /// The background color of the card.
  final Color? backgroundColor;

  /// The border color of the card.
  final Color? borderColor;

  /// The elevation of the card.
  final double? elevation;

  /// The gradient of the card.
  final Gradient? gradient;

  /// The width of the card.
  final double? width;

  /// The height of the card.
  final double? height;

  /// Whether to show a shadow behind the card.
  final bool showShadow;

  /// The custom border radius of the card.
  final BorderRadiusGeometry? customBorderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.only(bottom: 20),
      child: InkWell(onTap: onTap, child: child),
    );
  }
}

/// A card widget specifically designed to display a single transaction.
///
/// This widget shows details like title, subtitle, amount, and an icon.
class TransactionCard extends StatelessWidget {
  /// Creates a [TransactionCard] widget.
  const TransactionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.amount,
    this.isDebit,
    this.imageUrl,
    this.onTap,
    this.customIcon,
    this.showTrailing = false,
  });

  /// The title of the transaction.
  final String title;

  /// The subtitle of the transaction.
  final String? subtitle;

  /// The amount of the transaction.
  final String? amount;

  /// Whether the transaction is a debit.
  final bool? isDebit;

  /// The URL of the image to display.
  final String? imageUrl;

  /// The callback that is called when the card is tapped.
  final VoidCallback? onTap;

  /// A custom icon to display.
  final Widget? customIcon;

  /// Whether to show the trailing icon.
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    return BACard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: BAAppColors.grey100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      imageUrl ?? '',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.business,
                        color: BAAppColors.textSecondary,
                      ),
                    ),
                  )
                : customIcon ??
                      const Icon(
                        Icons.business,
                        color: BAAppColors.textSecondary,
                      ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.scrim,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: context.bodySmall?.copyWith(
                      color: context.colorScheme.inverseSurface,
                    ),
                  ),
                ],
              ],
            ),
          ),
          isDebit == null
              ? Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 20)
              : Text(
                  '${isDebit! ? '-' : '+'}${amount ?? ''}',
                  style: context.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDebit!
                        ? context.colorScheme.scrim
                        : context.colorScheme.surfaceTint,
                  ),
                ),
        ],
      ),
    );
  }
}

/// A card widget used to display a selected category.
///
/// This widget shows the category name, an image, and has a callback.
class CardCategorySelected extends StatelessWidget {
  /// Creates a [CardCategorySelected] widget.
  const CardCategorySelected({
    super.key,
    required this.onTap,
    this.categoryName,
    this.category,
    this.imageUrl,
  });

  /// The name of the category.
  final String? category;

  /// The name of the category.
  final String? categoryName;

  /// The widget to display as the image.
  final Widget? imageUrl;

  /// The callback that is called when the card is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFCBD5E0).withAlpha(150),
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(category ?? '', style: context.titleMedium),
                      ],
                    ),
                    Text(
                      categoryName ?? '',
                      style: context.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              imageUrl ??
                  Image.asset(
                    'assets/images/bill_category.png',
                    fit: BoxFit.cover,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A card widget that displays credit card information with custom styling per card type
class SwipeableCreditCard extends StatelessWidget {
  const SwipeableCreditCard({
    super.key,
    required this.data,
    this.isActive = false,
    this.isBalanceVisible = true,
    this.onToggleVisibility,
  });

  final CardModel data;
  final bool isActive;
  final bool isBalanceVisible;
  final VoidCallback? onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isActive ? 1.02 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            CardTypeUtils.getBorderRadius(data.cardType!),
          ),
          boxShadow: [
            BoxShadow(
              color: CardTypeUtils.getShadowColor(data.cardType!),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: _buildCardContent(context),
      ),
    );
  }

  /// Builds the content of the card with custom styling per card type
  Widget _buildCardContent(BuildContext context) {
    final cardType = data.cardType!;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: CardTypeUtils.getGradient(cardType),
        borderRadius: BorderRadius.circular(
          CardTypeUtils.getBorderRadius(cardType),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Background pattern
          _buildBackgroundPattern(cardType),

          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card holder name & Card type
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        data.cardHolderName,
                        style: context.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      CardTypeUtils.getDisplayName(cardType),
                      style: CardTypeUtils.getDisplayNameStyle(cardType),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Card tier
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data.cardTier,
                    style: context.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Card number
                Text(
                  FormatterUtils.maskCardNumber(data.cardNumber),
                  style: context.titleMedium?.copyWith(
                    color: Colors.white,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(),

                // Balance and visibility toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Balance
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.current.cardAvailableBalance,
                            style: context.bodySmall?.copyWith(
                              color: Colors.white.withAlpha(200),
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              key: ValueKey<bool>(isBalanceVisible),
                              isBalanceVisible
                                  ? FormatterUtils.formatBalance(
                                      data.availableBalance ?? 0,
                                    )
                                  : S.current.cardMaskedBalance,
                              style: context.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Toggle visibility button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(50),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            return RotationTransition(
                              turns: animation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: Icon(
                            key: ValueKey<bool>(isBalanceVisible),
                            CardTypeUtils.getVisibilityIcon(
                              cardType,
                              isBalanceVisible,
                            ),
                            size: 20,
                          ),
                        ),
                        color: Colors.white,
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          onToggleVisibility?.call();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build background pattern for each card type
  Widget _buildBackgroundPattern(CardType cardType) {
    switch (cardType) {
      case CardType.visa:
        return Positioned(
          right: -50,
          top: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withAlpha(12),
            ),
          ),
        );

      case CardType.mastercard:
        return Positioned(
          right: -30,
          bottom: -30,
          child: Row(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(25),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(25),
                ),
              ),
            ],
          ),
        );

      case CardType.discover:
        return Positioned(
          left: -60,
          bottom: -60,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.white.withAlpha(25), Colors.transparent],
              ),
            ),
          ),
        );
    }
  }
}
