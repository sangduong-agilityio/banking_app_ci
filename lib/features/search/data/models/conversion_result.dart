import 'package:banking_app/features/search/presentation/blocs/search_state.dart';

/// Detailed conversion output with source metadata.
class ConversionResult {
  final double rate;
  final double toAmount;
  final ExchangeRateStatus status;
  final DateTime? lastUpdated;

  const ConversionResult({
    required this.rate,
    required this.toAmount,
    required this.status,
    this.lastUpdated,
  });
}
