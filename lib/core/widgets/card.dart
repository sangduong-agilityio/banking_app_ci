import 'package:banking_app/app/themes/app_colors.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
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
