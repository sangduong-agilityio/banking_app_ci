import 'package:banking_app/app/themes/app_colors.dart';
import 'package:banking_app/app/themes/typography.dart';
import 'package:flutter/material.dart';

enum CardType { basic, elevated, outline, gradient }

class BACard extends StatelessWidget {
  final Widget child;
  final CardType type;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? elevation;
  final Gradient? gradient;
  final double? width;
  final double? height;
  final bool showShadow;
  final BorderRadiusGeometry? customBorderRadius;

  const BACard({
    super.key,
    required this.child,
    this.type = CardType.basic,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          // borderRadius: customBorderRadius ?? BorderRadius.circular(borderRadius ?? 16),
          child: Container(
            decoration: _buildDecoration(),
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    switch (type) {
      case CardType.basic:
        return BoxDecoration(
          color: backgroundColor ?? AppColors.surface,
          borderRadius:
              customBorderRadius ?? BorderRadius.circular(borderRadius ?? 16),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        );

      case CardType.elevated:
        return BoxDecoration(
          color: backgroundColor ?? AppColors.surface,
          borderRadius:
              customBorderRadius ?? BorderRadius.circular(borderRadius ?? 16),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        );

      case CardType.outline:
        return BoxDecoration(
          color: backgroundColor ?? AppColors.surface,
          border: Border.all(color: borderColor ?? AppColors.border, width: 1),
          borderRadius:
              customBorderRadius ?? BorderRadius.circular(borderRadius ?? 16),
        );

      case CardType.gradient:
        return BoxDecoration(
          gradient: gradient ?? AppColors.primaryGradient,
          borderRadius:
              customBorderRadius ?? BorderRadius.circular(borderRadius ?? 16),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        );
    }
  }
}

class TransactionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final bool isDebit;
  final String? iconUrl;
  final IconData? iconData;
  final VoidCallback? onTap;

  const TransactionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.isDebit = true,
    this.iconUrl,
    this.iconData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BACard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: iconData != null
                ? Icon(iconData, color: AppColors.textSecondary)
                : iconUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      iconUrl!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.business,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : const Icon(Icons.business, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            '${isDebit ? '-' : '+'}$amount',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: isDebit ? AppColors.textPrimary : AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class BalanceCard extends StatelessWidget {
  final String cardNumber;
  final String cardHolder;
  final String balance;
  final String expiryDate;
  final String? cardType;
  final bool showBalance;
  final VoidCallback? onTap;
  final VoidCallback? onToggleBalance;

  const BalanceCard({
    super.key,
    required this.cardNumber,
    required this.cardHolder,
    required this.balance,
    required this.expiryDate,
    this.cardType,
    this.showBalance = true,
    this.onTap,
    this.onToggleBalance,
  });

  @override
  Widget build(BuildContext context) {
    return BACard(
      type: CardType.gradient,
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Balance',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.white.withOpacity(0.8),
                ),
              ),
              if (onToggleBalance != null)
                GestureDetector(
                  onTap: onToggleBalance,
                  child: Icon(
                    showBalance ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.white.withOpacity(0.8),
                    size: 20,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            showBalance ? balance : '••••••',
            style: AppTypography.moneyAmount.copyWith(
              color: AppColors.white,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 20),

          // Card Number
          Text(
            _formatCardNumber(cardNumber),
            style: AppTypography.cardNumber.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 16),

          // Card Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Holder',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.white.withOpacity(0.6),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cardHolder,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Expires',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.white.withOpacity(0.6),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expiryDate,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              if (cardType != null)
                Image.asset(
                  'assets/images/$cardType.png',
                  width: 32,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(width: 32, height: 20),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCardNumber(String cardNumber) {
    if (cardNumber.length >= 4) {
      String lastFour = cardNumber.substring(cardNumber.length - 4);
      return '•••• •••• •••• $lastFour';
    }
    return cardNumber;
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? valueColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BACard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  size: 20,
                  color: iconColor ?? AppColors.textSecondary,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTypography.heading3.copyWith(
              color: valueColor ?? AppColors.textPrimary,
              fontSize: 20,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? backgroundColor;

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return BACard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      backgroundColor: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (iconColor ?? AppColors.primary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, color: iconColor ?? AppColors.primary, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTypography.labelMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
