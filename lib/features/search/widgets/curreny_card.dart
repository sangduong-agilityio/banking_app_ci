import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/features/search/models/currency_model.dart';
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

class CurrencySelector extends StatelessWidget {
  final String title;
  final List<CurrencyModel> currencies;
  final String selectedCurrency;
  final Function(String) onCurrencySelected;

  const CurrencySelector({
    super.key,
    required this.title,
    required this.currencies,
    required this.selectedCurrency,
    required this.onCurrencySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: context.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final currency = currencies[index];
                  final isSelected = currency.code == selectedCurrency;
                  return InkWell(
                    onTap: () => onCurrencySelected(currency.code),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: currency.code,
                                    style: context.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? context.colorScheme.secondary
                                          : context.colorScheme.onSurface
                                                .withOpacity(0.7),
                                    ),
                                  ),
                                  TextSpan(
                                    text: " ( ${currency.name} )",
                                    style: context.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? context.colorScheme.secondary
                                          : context.colorScheme.onSurface
                                                .withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check,
                              color: context.colorScheme.secondary,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
