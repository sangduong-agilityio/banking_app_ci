import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:flutter/material.dart';

class BillCategoryCard extends StatelessWidget {
  final String? billCategory;
  final String? billCategoryName;
  final Widget? imageUrl;
  final VoidCallback onTap;

  const BillCategoryCard({
    super.key,
    required this.onTap,
    this.billCategoryName,
    this.billCategory,
    this.imageUrl,
  });

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
                        Text(billCategory ?? '', style: context.titleMedium),
                      ],
                    ),
                    Text(
                      billCategoryName ?? S.current.payBillInternetDescription,
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
