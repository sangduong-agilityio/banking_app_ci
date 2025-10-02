import 'package:banking_app/app/themes/app_colors.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/utils/formatters.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:flutter/material.dart';

class BACard extends StatelessWidget {
  final Widget child;
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
      margin: margin ?? const EdgeInsets.only(bottom: 20),
      child: InkWell(onTap: onTap, child: child),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? amount;
  final bool? isDebit;
  final String? imageUrl;
  final VoidCallback? onTap;
  final Widget? customIcon;
  final bool showTrailing;

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

class CardCategorySelected extends StatelessWidget {
  const CardCategorySelected({
    super.key,
    required this.onTap,
    this.categoryName,
    this.category,
    this.imageUrl,
  });
  final String? category;
  final String? categoryName;
  final Widget? imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: Color(0xFFCBD5E0).withAlpha(150), blurRadius: 5),
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

class SwipeableCreditCard extends StatelessWidget {
  final CardModel data;
  final bool isActive;

  const SwipeableCreditCard({
    super.key,
    required this.data,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isActive ? 1.02 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: _buildCardContent(context),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: data.cardType?.gradient,
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.cardHolderName,
                style: context.displaySmall?.copyWith(
                  color: context.colorScheme.onPrimary,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 32),
              Text(
                data.cardTier,
                style: context.titleSmall?.copyWith(
                  color: context.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                FormatterUtils.maskCardNumber(data.cardNumber),
                style: context.titleMedium?.copyWith(
                  color: context.colorScheme.onPrimary,
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      FormatterUtils.formatBalance(data.availableBalance ?? 0),
                      style: context.headlineMedium?.copyWith(
                        color: context.colorScheme.onPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    data.cardType?.displayName ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
