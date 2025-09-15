import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:flutter/material.dart';

class CurrencyCard extends StatelessWidget {
  final String label;
  final String currency;
  final TextEditingController controller;
  final VoidCallback onCurrencyTap;
  final bool isLoading;
  final ValueChanged<String?>? onChanged;

  const CurrencyCard({
    super.key,
    required this.label,
    required this.currency,
    required this.controller,
    required this.onCurrencyTap,
    this.isLoading = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.bodySmall?.copyWith(
            color: context.colorScheme.inverseSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        BATextField(
          controller: controller,
          name: currency,
          hint: S.current.searchAmoutTitle,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: onChanged,
          suffixIcon: GestureDetector(
            onTap: onCurrencyTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: context.colorScheme.outline.withOpacity(0.5),
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currency,
                    style: context.titleMedium?.copyWith(
                      color: context.colorScheme.inverseSurface,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.unfold_more,
                    size: 20,
                    color: context.colorScheme.inverseSurface,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ExchangeBox extends StatelessWidget {
  final CurrencyCard fromCard;
  final CurrencyCard toCard;
  final Widget swapButton;
  final String? exchangeRate;
  final bool isButtonEnabled;

  const ExchangeBox({
    super.key,
    required this.fromCard,
    required this.toCard,
    required this.swapButton,
    this.exchangeRate,
    required this.isButtonEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCBD5E0).withAlpha(150),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          fromCard,
          const SizedBox(height: 20),
          Center(child: swapButton),
          toCard,
          if (exchangeRate != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.current.searchCurrentRateCalculatorTitle,
                  style: context.titleSmall?.copyWith(
                    color: context.colorScheme.secondary,
                  ),
                ),
                Text(
                  exchangeRate ?? '',
                  style: context.titleSmall?.copyWith(
                    color: context.colorScheme.scrim,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 32),
          BAElevatedButton(
            isDisabled: !isButtonEnabled,
            padding: EdgeInsets.zero,
            text: S.current.searchExchangeButton,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
