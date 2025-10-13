import 'package:banking_app/features/search/models/currency_model.dart';
import 'package:banking_app/features/search/models/exchange_rate_model.dart';
import 'package:banking_app/features/search/models/interest_rate_model.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_state.freezed.dart';

/// Represents the state of the search feature.
class SearchState extends Equatable {
  /// Creates a [SearchState] object.
  const SearchState({
    this.status = const SearchStatus.initial(),
    this.fromCurrency,
    this.toCurrency,
    this.exchangeRates,
    this.fromAmount,
    this.toAmount,
    this.interestRates,
    this.currencies,
    this.exchangeRate,
    this.lastUpdated,
    this.isFromCache = false,
    this.exchangeRateStatus = ExchangeRateStatus.noData,
    this.lastExchangeRateUpdate,
    this.exchangeRateRequestId = 0,
    this.isOnline = true,
  });

  /// The current status of the search feature.
  final SearchStatus status;

  /// The list of exchange rates.
  final List<ExchangeRateModel>? exchangeRates;

  /// The currency to convert from.
  final String? fromCurrency;

  /// The currency to convert to.
  final String? toCurrency;

  /// The amount in the \"from\" currency.
  final double? fromAmount;

  /// The amount in the \"to\" currency.
  final double? toAmount;

  /// The list of interest rates.
  final List<InterestRateModel>? interestRates;

  /// The list of available currencies.
  final List<CurrencyModel>? currencies;

  /// The current exchange rate.
  final double? exchangeRate;

  /// The timestamp when the exchange rates were last updated.
  final DateTime? lastUpdated;

  /// Whether the exchange rates are from the cache.
  final bool isFromCache;

  /// The status of the current exchange rate (fresh, stale, or no data).
  final ExchangeRateStatus exchangeRateStatus;

  /// The timestamp when the current exchange rate was last updated.
  final DateTime? lastExchangeRateUpdate;

  /// A unique identifier for the current exchange rate request.
  final int exchangeRateRequestId;

  final bool isOnline;

  /// Creates a copy of the current [SearchState] with the given fields replaced
  /// with the new values.
  SearchState copyWith({
    SearchStatus? status,
    List<ExchangeRateModel>? exchangeRates,
    String? fromCurrency,
    String? toCurrency,
    double? fromAmount,
    double? toAmount,
    List<InterestRateModel>? interestRates,
    List<CurrencyModel>? currencies,
    double? exchangeRate,
    DateTime? lastUpdated,
    bool? isFromCache,
    ExchangeRateStatus? exchangeRateStatus,
    DateTime? lastExchangeRateUpdate,
    int? exchangeRateRequestId,
    bool? isOnline,
  }) {
    return SearchState(
      status: status ?? this.status,
      exchangeRates: exchangeRates ?? this.exchangeRates,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      fromAmount: fromAmount ?? this.fromAmount,
      toAmount: toAmount ?? this.toAmount,
      interestRates: interestRates ?? this.interestRates,
      currencies: currencies ?? this.currencies,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isFromCache: isFromCache ?? this.isFromCache,
      exchangeRateStatus: exchangeRateStatus ?? this.exchangeRateStatus,
      lastExchangeRateUpdate:
          lastExchangeRateUpdate ?? this.lastExchangeRateUpdate,
      exchangeRateRequestId:
          exchangeRateRequestId ?? this.exchangeRateRequestId,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  @override
  List<Object?> get props => [
    status,
    exchangeRates,
    fromCurrency,
    toCurrency,
    fromAmount,
    toAmount,
    interestRates,
    currencies,
    exchangeRate,
    lastUpdated,
    isFromCache,
    exchangeRateStatus,
    lastExchangeRateUpdate,
    exchangeRateRequestId,
    isOnline,
  ];
}

/// Represents the status of an exchange rate.
enum ExchangeRateStatus {
  /// The exchange rate is fresh and up-to-date.
  fresh,

  /// The exchange rate is from the cache and may be outdated.
  stale,

  /// There is no data for the exchange rate.
  noData,
}

/// An extension on [ExchangeRateStatus] to provide additional functionality.

extension ExchangeRateStatusExtension on ExchangeRateStatus {
  /// A user-friendly display name for the status.
  String get displayName {
    switch (this) {
      case ExchangeRateStatus.fresh:
        return 'Live rate';
      case ExchangeRateStatus.stale:
        return 'Offline rate';
      case ExchangeRateStatus.noData:
        return 'No rate';
    }
  }

  /// Whether the exchange rate is from the offline cache.
  bool get isOffline => this == ExchangeRateStatus.stale;

  /// Whether there is data for the exchange rate.
  bool get hasData => this != ExchangeRateStatus.noData;
}

/// Represents the status of the search feature.
@freezed
sealed class SearchStatus with _$SearchStatus {
  /// The initial status.
  const factory SearchStatus.initial() = SearchStatusInitial;

  /// The loading status.
  const factory SearchStatus.loading() = SearchStatusLoading;

  /// The success status.
  const factory SearchStatus.success() = SearchStatusSuccess;

  /// The failure status.
  const factory SearchStatus.failure() = SearchStatusFailure;
}
