import 'package:banking_app/features/search/data/models/currency_model.dart';
import 'package:banking_app/features/search/data/models/exchange_rate_model.dart';
import 'package:banking_app/features/search/data/models/interest_rate_model.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_state.freezed.dart';

class SearchState extends Equatable {
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

  final SearchStatus status;
  final List<ExchangeRateModel>? exchangeRates;
  final double? exchangeRate;
  final bool isFromCache;
  final ExchangeRateStatus exchangeRateStatus;
  final DateTime? lastUpdated;
  final DateTime? lastExchangeRateUpdate;
  final int exchangeRateRequestId;
  final String? fromCurrency;
  final String? toCurrency;
  final double? fromAmount;
  final double? toAmount;
  final List<CurrencyModel>? currencies;
  final List<InterestRateModel>? interestRates;
  final bool isOnline;

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
    bool clearAmounts = false,
  }) {
    return SearchState(
      status: status ?? this.status,
      exchangeRates: exchangeRates ?? this.exchangeRates,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      fromAmount: clearAmounts ? null : (fromAmount ?? this.fromAmount),
      toAmount: clearAmounts ? null : (toAmount ?? this.toAmount),
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

/// Exchange Rate Status
enum ExchangeRateStatus { fresh, stale, noData }

/// Extension methods for ExchangeRateStatus
extension ExchangeRateStatusX on ExchangeRateStatus {
  String get label {
    switch (this) {
      case ExchangeRateStatus.fresh:
        return 'Live rate';
      case ExchangeRateStatus.stale:
        return 'Offline rate';
      case ExchangeRateStatus.noData:
        return 'No data';
    }
  }

  bool get isOffline => this == ExchangeRateStatus.stale;
  bool get hasData => this != ExchangeRateStatus.noData;
}

/// Represents the status of the search feature.
@freezed
sealed class SearchStatus with _$SearchStatus {
  const factory SearchStatus.initial() = SearchStatusInitial;
  const factory SearchStatus.loading() = SearchStatusLoading;
  const factory SearchStatus.success() = SearchStatusSuccess;
  const factory SearchStatus.failure() = SearchStatusFailure;
}
