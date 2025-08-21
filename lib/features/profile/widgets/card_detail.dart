import 'package:banking_app/app/themes/app_colors.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:flutter/material.dart';

class CreditCardDetail extends StatefulWidget {
  const CreditCardDetail({super.key});

  @override
  State<CreditCardDetail> createState() => _CreditCardDetailState();
}

class _CreditCardDetailState extends State<CreditCardDetail> {
  bool _isCardNumberVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: BAAppColors.primaryGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),

              Row(
                children: [
                  Text(
                    _isCardNumberVisible
                        ? '1234567891235'
                        : '•••• •••• •••• 1235',
                    style: context.displaySmall?.copyWith(
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(width: 26),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCardNumberVisible = !_isCardNumberVisible;
                      });
                    },
                    child: Icon(
                      _isCardNumberVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: context.colorScheme.onPrimary,
                      size: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.current.accountCardHolderTitle,
                        style: context.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gega Lee',
                        style: context.bodySmall?.copyWith(
                          color: context.colorScheme.onPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.current.accountExpiryDateTitle,
                        style: context.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '02/30',
                        style: context.bodySmall?.copyWith(
                          color: context.colorScheme.onPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 40,
                    height: 25,
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: context.colorScheme.onTertiaryContainer,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: context.colorScheme.onPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
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
