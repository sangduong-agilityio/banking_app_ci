import 'package:banking_app/features/search/data/models/currency_model.dart';
import 'package:banking_app/features/search/data/models/exchange_model.dart';
import 'package:banking_app/features/search/data/models/exchange_rate_model.dart';
import 'package:banking_app/features/search/data/models/interest_rate_model.dart';

/// Abstract repository for search/exchange operations.
///
/// KEY CHANGE: Removed obsolete getRateStatus() and getLastRateUpdate() methods.
/// Reason: Data freshness is now tracked in SearchBloc (which manages state),
/// not in the repository. The repository simply provides data; the BLoC decides
/// whether it's fresh, stale, or unavailable based on the response and connectivity.
abstract class SearchRepository {
  /// Fetch list of exchange rates.
  /// Returns cached data if available and cache is valid.
  /// Falls back to cache on network error.
  Future<List<ExchangeRateModel>> fetchExchangeRates({
    bool forceRefresh = false,
  });

  /// Fetch list of interest rates.
  Future<List<InterestRateModel>> fetchInterestRates();

  /// Perform a currency exchange with given amount.
  /// Caches the rate for offline use.
  ///
  /// Throws exception if:
  /// - Network error AND no cached rate available
  /// - Invalid rate received from API (rate <= 0)
  Future<ExchangeModel> exchange({
    required String fromCurrency,
    required String toCurrency,
    required double fromAmount,
  });

  /// Fetch list of available currencies.
  /// Returns cached data if available and cache is valid.
  /// Falls back to cache on network error.
  Future<List<CurrencyModel>> fetchCurrencies();

  /// Convert amount from one currency to another.
  /// Returns converted amount.
  ///
  /// Tries API first, falls back to cached rate if offline.
  /// Returns cached rate even if stale (BLoC will mark as stale).
  ///
  /// Throws exception if no rate available (neither API nor cache).
  Future<double> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  });
}
