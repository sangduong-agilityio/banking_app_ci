import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/dialog.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/features/search/states/search_state.dart';
import 'package:banking_app/features/search/widgets/offline_rate_indicator.dart';
import 'package:flutter/material.dart';

/// A card widget for displaying currency information and input.
class CurrencyCard extends StatelessWidget {
  /// The label for the card (e.g., \"From\", \"To\").
  final String label;

  /// The currency code (e.g., \"USD\").
  final String currency;

  /// The text editing controller for the amount input field.
  final TextEditingController controller;

  /// A callback function that is called when the currency is tapped.
  final VoidCallback onCurrencyTap;

  /// Whether the card is in a loading state.
  final bool isLoading;

  /// A callback function that is called when the amount is changed.
  final ValueChanged<String?>? onChanged;

  /// Creates a [CurrencyCard] object.
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
                    color: context.colorScheme.outline.withAlpha(100),
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

/// A widget that displays the currency exchange interface.
class ExchangeBox extends StatelessWidget {
  /// The card for the \"from\" currency.
  final CurrencyCard fromCard;

  /// The card for the \"to\" currency.
  final CurrencyCard toCard;

  /// The button to swap the currencies.
  final Widget swapButton;

  /// The current exchange rate.
  final String? exchangeRate;

  /// Whether the exchange button is enabled.
  final bool isButtonEnabled;

  /// The status of the exchange rate (fresh, stale, or no data).
  final ExchangeRateStatus? rateStatus;

  /// The timestamp when the exchange rate was last updated.
  final DateTime? lastRateUpdate;

  /// Creates an [ExchangeBox] object.
  const ExchangeBox({
    super.key,
    required this.fromCard,
    required this.toCard,
    required this.swapButton,
    this.exchangeRate,
    required this.isButtonEnabled,
    this.rateStatus,
    this.lastRateUpdate,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.current.searchCurrentRateCalculatorTitle,
                      style: context.titleSmall?.copyWith(
                        color: context.colorScheme.secondary,
                      ),
                    ),

                    if (rateStatus != null)
                      OfflineRateIndicator(
                        status: rateStatus!,
                        lastUpdate: lastRateUpdate,
                      ),
                  ],
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
            onPressed: () {
              if (rateStatus == ExchangeRateStatus.stale) {
                _showOfflineExchangeDialog(context);
              } else {
                _performExchange(context);
              }
            },
          ),
        ],
      ),
    );
  }

  /// Shows a dialog to confirm the use of an offline exchange rate.
  Future<void> _showOfflineExchangeDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (ctx) => BADialog(
        title: S.current.searchOfflineExchangeTitle,
        content: S.current.searchOfflineExchangeContent,
        confirmButton: S.current.searchContinueButton,
        confirmCancel: S.current.searchCancelButton,
        onAccept: () async {
          Navigator.pop(context);
          _performExchange(context);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  /// Performs the exchange and shows a snackbar with the result.
  void _performExchange(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          rateStatus == ExchangeRateStatus.stale
              ? S.current.searchPerformExchangeStatusOffline
              : S.current.searchPerformExchangeStatusSuccess,
        ),
        backgroundColor: rateStatus == ExchangeRateStatus.stale
            ? context.colorScheme.inversePrimary
            : context.colorScheme.surfaceTint,
      ),
    );
  }
}
