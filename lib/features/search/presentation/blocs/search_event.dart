import 'package:equatable/equatable.dart';

/// The base class for all events related to the search feature.
abstract class SearchEvt extends Equatable {
  const SearchEvt();

  @override
  List<Object?> get props => [];
}

/// Event to initialize the interest rate screen.
class InterestRateInitializeEvt extends SearchEvt {}

/// Event to initialize the exchange rate screen.
class ExchangeRateInitializeEvt extends SearchEvt {}

/// Event to initialize the currency exchange screen.
class ExchangeInitializeEvt extends SearchEvt {
  const ExchangeInitializeEvt(this.fromCurrency, this.toCurrency);

  final String? fromCurrency;
  final String? toCurrency;

  @override
  List<Object?> get props => [fromCurrency, toCurrency];
}

/// Event triggered when the user changes the \"from\" or \"to\" currency.
class ExchangeRateChangedEvt extends SearchEvt {
  const ExchangeRateChangedEvt(this.fromCurrency, this.toCurrency);

  final String fromCurrency;
  final String toCurrency;

  @override
  List<Object?> get props => [fromCurrency, toCurrency];
}

/// Event to convert an amount from one currency to another.
class ConvertCurrencyEvt extends SearchEvt {
  const ConvertCurrencyEvt(this.amount, {this.isFromAmount = true});

  final double amount;
  final bool isFromAmount;

  @override
  List<Object?> get props => [amount, isFromAmount];
}

/// Event to swap the \"from\" and \"to\" currencies.
class SwapCurrenciesEvt extends SearchEvt {}

/// Event triggered when the user selects a currency.
class SelectCurrencyEvt extends SearchEvt {
  const SelectCurrencyEvt(this.isFromCurrency, this.currency);

  final bool isFromCurrency;
  final String currency;

  @override
  List<Object?> get props => [isFromCurrency, currency];
}

/// Event to refresh the exchange rates.
class ExchangeRateRefreshEvt extends SearchEvt {
  const ExchangeRateRefreshEvt({this.forceRefresh = false});

  final bool forceRefresh;

  @override
  List<Object?> get props => [forceRefresh];
}

class CheckConnectivityEvt extends SearchEvt {
  final bool isOnline;

  const CheckConnectivityEvt(this.isOnline);

  @override
  List<Object?> get props => [isOnline];
}
