import 'package:banking_app/features/search/models/currency_model.dart';
import 'package:banking_app/features/search/models/exchange_rate_model.dart';
import 'package:banking_app/features/search/models/interest_rate_model.dart';
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
  });

  final SearchStatus status;
  final List<ExchangeRateModel>? exchangeRates;
  final String? fromCurrency;
  final String? toCurrency;
  final double? fromAmount;
  final double? toAmount;
  final List<InterestRateModel>? interestRates;
  final List<CurrencyModel>? currencies;
  final double? exchangeRate;
  final DateTime? lastUpdated;
  final bool isFromCache;
  final ExchangeRateStatus exchangeRateStatus;
  final DateTime? lastExchangeRateUpdate;
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
  ];
}

enum ExchangeRateStatus { fresh, stale, noData }

extension ExchangeRateStatusExtension on ExchangeRateStatus {
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

  bool get isOffline => this == ExchangeRateStatus.stale;
  bool get hasData => this != ExchangeRateStatus.noData;
}

@freezed
sealed class SearchStatus with _$SearchStatus {
  const factory SearchStatus.initial() = SearchStatusInitial;
  const factory SearchStatus.loading() = SearchStatusLoading;
  const factory SearchStatus.success() = SearchStatusSuccess;
  const factory SearchStatus.failure() = SearchStatusFailure;
}
