import 'package:banking_app/features/search/presentation/blocs/search_state.dart';
import 'package:banking_app/features/search/data/models/currency_model.dart';
import 'package:banking_app/features/search/data/models/exchange_model.dart';
import 'package:banking_app/features/search/data/models/exchange_rate_model.dart';
import 'package:banking_app/features/search/data/models/interest_rate_model.dart';

/// Repository for handling currency exchange and interest rate data.
abstract class SearchRepository {
  Future<ExchangeModel> exchange({
    required String fromCurrency,
    required String toCurrency,
    required double fromAmount,
  });

  Future<List<ExchangeRateModel>> fetchExchangeRates({
    bool forceRefresh = false,
  });

  Future<List<InterestRateModel>> fetchInterestRates();

  Future<List<CurrencyModel>> fetchCurrencies();

  Future<double> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  });

  ExchangeRateStatus getRateStatus(String fromCurrency, String toCurrency);

  DateTime? getLastRateUpdate(String fromCurrency, String toCurrency);
}
