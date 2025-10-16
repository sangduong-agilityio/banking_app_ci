import 'package:equatable/equatable.dart';

abstract class SearchEvt extends Equatable {
  const SearchEvt();

  @override
  List<Object?> get props => [];
}

/// Interest Rate Events
class InterestRateInitializeEvt extends SearchEvt {
  const InterestRateInitializeEvt();
}

/// Initializes the Exchange Rate screen.
class ExchangeRateInitializeEvt extends SearchEvt {
  const ExchangeRateInitializeEvt();
}

/// Refreshes the Exchange Rate data (can force API call).
class ExchangeRateRefreshEvt extends SearchEvt {
  const ExchangeRateRefreshEvt({this.forceRefresh = false});

  final bool forceRefresh;

  @override
  List<Object?> get props => [forceRefresh];
}

/// Triggered when user changes the from/to currency pair.
class ExchangeRateChangedEvt extends SearchEvt {
  const ExchangeRateChangedEvt(this.fromCurrency, this.toCurrency);

  final String fromCurrency;
  final String toCurrency;

  @override
  List<Object?> get props => [fromCurrency, toCurrency];
}

/// Initializes the Exchange screen.
class ExchangeInitializeEvt extends SearchEvt {
  const ExchangeInitializeEvt(this.fromCurrency, this.toCurrency);

  final String? fromCurrency;
  final String? toCurrency;

  @override
  List<Object?> get props => [fromCurrency, toCurrency];
}

/// Converts an entered amount between currencies.
class ConvertCurrencyEvt extends SearchEvt {
  const ConvertCurrencyEvt(this.amount, {this.isFromAmount = true});

  final double amount;
  final bool isFromAmount;

  @override
  List<Object?> get props => [amount, isFromAmount];
}

/// Swaps the from/to currencies.
class SwapCurrenciesEvt extends SearchEvt {
  const SwapCurrenciesEvt();
}

/// Triggered when user manually selects a currency.
class SelectCurrencyEvt extends SearchEvt {
  const SelectCurrencyEvt(this.isFromCurrency, this.currency);

  final bool isFromCurrency;
  final String currency;

  @override
  List<Object?> get props => [isFromCurrency, currency];
}

/// Triggered when connectivity changes (online/offline).
class CheckConnectivityEvt extends SearchEvt {
  const CheckConnectivityEvt(this.isOnline);

  final bool isOnline;

  @override
  List<Object?> get props => [isOnline];
}
