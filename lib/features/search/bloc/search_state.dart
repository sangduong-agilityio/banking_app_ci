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
  });

  final SearchStatus status;
  final List<ExchangeRateModel>? exchangeRates;
  final String? fromCurrency;
  final String? toCurrency;
  final String? fromAmount;
  final String? toAmount;
  final List<InterestRateModel>? interestRates;
  final List<CurrencyModel>? currencies;
  final double? exchangeRate;

  SearchState copyWith({
    SearchStatus? status,
    List<ExchangeRateModel>? exchangeRates,
    String? fromCurrency,
    String? toCurrency,
    String? fromAmount,
    String? toAmount,
    List<InterestRateModel>? interestRates,
    List<CurrencyModel>? currencies,
    double? exchangeRate,
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
  ];
}

@freezed
sealed class SearchStatus with _$SearchStatus {
  const factory SearchStatus.initial() = SearchStatusInitial;
  const factory SearchStatus.loading() = SearchStatusLoading;
  const factory SearchStatus.success() = SearchStatusSuccess;
  const factory SearchStatus.failure() = SearchStatusFailure;
}
