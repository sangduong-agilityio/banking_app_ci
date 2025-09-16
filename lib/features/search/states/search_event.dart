import 'package:equatable/equatable.dart';

abstract class SearchEvt extends Equatable {
  const SearchEvt();

  @override
  List<Object?> get props => [];
}

class InterestRateInitializeEvt extends SearchEvt {}

class ExchangeRateInitializeEvt extends SearchEvt {}

class ExchangeInitializeEvt extends SearchEvt {
  final String? fromCurrency;
  final String? toCurrency;

  const ExchangeInitializeEvt(this.fromCurrency, this.toCurrency);

  @override
  List<Object?> get props => [fromCurrency, toCurrency];
}

class ExchangeRateChangedEvt extends SearchEvt {
  final String fromCurrency;
  final String toCurrency;

  const ExchangeRateChangedEvt(this.fromCurrency, this.toCurrency);

  @override
  List<Object?> get props => [fromCurrency, toCurrency];
}

class ConvertCurrencyEvt extends SearchEvt {
  final double amount;
  final bool isFromAmount;
  const ConvertCurrencyEvt(this.amount, {this.isFromAmount = true});

  @override
  List<Object?> get props => [amount, isFromAmount];
}

class SwapCurrenciesEvt extends SearchEvt {}

class SelectCurrencyEvt extends SearchEvt {
  final bool isFromCurrency;
  final String currency;

  const SelectCurrencyEvt(this.isFromCurrency, this.currency);

  @override
  List<Object?> get props => [isFromCurrency, currency];
}
