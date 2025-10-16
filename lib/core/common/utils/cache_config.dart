class CacheConfig {
  /// Exchange rates are fetched frequently (5 min validity)
  /// This keeps conversion rates relatively fresh
  static const Duration exchangeRateValidity = Duration(minutes: 5);

  /// Currency list is relatively static (24 hour validity)
  /// Unless you add/remove currencies, this can be cached longer
  static const Duration currencyListValidity = Duration(hours: 24);

  /// Offline rates cached during conversions (24 hour validity)
  /// When user converts offline, we store the rate for 24h reuse
  static const Duration offlineRateValidity = Duration(hours: 24);

  /// Interest rates change slowly (48 hour validity)
  static const Duration interestRateValidity = Duration(hours: 48);
}
