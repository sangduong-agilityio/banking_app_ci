import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/formatters.dart';
import 'package:banking_app/features/search/states/search_state.dart';
import 'package:flutter/material.dart';

/// A widget that indicates the status of an exchange rate (live, offline, or no data).
class OfflineRateIndicator extends StatelessWidget {
  /// The status of the exchange rate.
  final ExchangeRateStatus status;

  /// The timestamp when the exchange rate was last updated.
  final DateTime? lastUpdate;

  const OfflineRateIndicator({
    super.key,
    required this.status,
    this.lastUpdate,
  });

  @override
  Widget build(BuildContext context) {
    if (status == ExchangeRateStatus.noData) {
      return const SizedBox.shrink();
    }

    Color color;
    String message;
    IconData icon;

    switch (status) {
      case ExchangeRateStatus.fresh:
        color = context.colorScheme.surfaceTint;
        message = S.current.searchLiveRateTitle;
        icon = Icons.wifi;
        break;
      case ExchangeRateStatus.stale:
        color = context.colorScheme.inversePrimary;
        message = S.current.searchOfflineRateTitle(
          FormatterUtils.formatLastUpdated(lastUpdate ?? DateTime.now()),
        );
        icon = Icons.wifi_off;
        break;
      case ExchangeRateStatus.noData:
        return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(100), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            message,
            style: context.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
