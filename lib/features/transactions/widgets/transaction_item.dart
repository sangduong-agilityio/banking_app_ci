import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    this.icon,
    this.iconColor,
    this.title,
    this.subtitle,
    this.amount,
    this.amountColor,
  });

  final Widget? icon;
  final Color? iconColor;
  final String? title;
  final String? subtitle;
  final String? amount;
  final Color? amountColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: icon),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title?.isNotEmpty ?? false)
                  Text(
                    title ?? '',
                    style: context.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (subtitle?.isNotEmpty ?? false) const SizedBox(height: 2),
                if (subtitle?.isNotEmpty ?? false)
                  Text(
                    subtitle ?? '',
                    style: context.bodyMedium?.copyWith(
                      color: context.colorScheme.inverseSurface,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            amount ?? '',
            style: context.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
