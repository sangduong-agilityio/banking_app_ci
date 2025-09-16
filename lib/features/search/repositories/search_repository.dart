import 'package:banking_app/core/api/api_client.dart';
import 'package:banking_app/core/env/env.dart';
import 'package:banking_app/features/search/models/currency_model.dart';
import 'package:banking_app/features/search/models/exchange_model.dart';
import 'package:banking_app/features/search/models/exchange_rate_model.dart';
import 'package:banking_app/features/search/models/interest_rate_model.dart';

abstract class SearchRepository {
  Future<ExchangeModel> exchange({
    required String fromCurrency,
    required String toCurrency,
    required double fromAmount,
  });
  Future<List<ExchangeRateModel>> fetchExchangeRates();
  Future<List<InterestRateModel>> fetchInterestRates();
  Future<List<CurrencyModel>> fetchCurrencies();

  Future<double> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  });
}

class SearchRepositoryImplement implements SearchRepository {
  final BankingApiClient _client;

  SearchRepositoryImplement({required BankingApiClient client})
    : _client = client;

  @override
  Future<List<ExchangeRateModel>> fetchExchangeRates() async {
    String apiUrl = '${Env.endPoint}exchange_rates';
    final response = await _client.get(
      apiUrl,
      queryParams: {'select': 'country,flag,buy,sell'},
    );
    final jsonData = response.data;
    final exchangeRates = (jsonData as List)
        .map((json) => ExchangeRateModel.fromJson(json))
        .toList();
    return exchangeRates;
  }

  @override
  Future<List<InterestRateModel>> fetchInterestRates() async {
    String apiUrl = '${Env.endPoint}interest_rates';
    final response = await _client.get(
      apiUrl,
      queryParams: {'select': 'id,type,period,rate'},
    );
    final jsonData = response.data;

    final interestRates = (jsonData as List)
        .map((json) => InterestRateModel.fromJson(json))
        .toList();

    return interestRates;
  }

  @override
  Future<ExchangeModel> exchange({
    required String fromCurrency,
    required String toCurrency,
    required double fromAmount,
  }) async {
    final apiUrl = '${Env.endPoint}exchange';

    final response = await _client.get(
      apiUrl,
      queryParams: {
        'select': 'from_currency,to_currency,from_amount,to_amount,rate',
        'from_currency': 'eq.$fromCurrency',
        'to_currency': 'eq.$toCurrency',
        'limit': '1',
      },
    );

    final jsonData = (response.data as List).first;
    final rate = double.tryParse(jsonData['rate'].toString()) ?? 0;
    final toAmount = fromAmount * rate;

    return ExchangeModel(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      fromAmount: fromAmount,
      toAmount: toAmount,
      rate: rate,
    );
  }

  @override
  Future<List<CurrencyModel>> fetchCurrencies() async {
    String apiUrl = '${Env.endPoint}currencies';
    final response = await _client.get(
      apiUrl,
      queryParams: {'select': 'code,name'},
    );
    final jsonData = response.data;
    return (jsonData as List)
        .map((json) => CurrencyModel.fromJson(json))
        .toList();
  }

  @override
  Future<double> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    final exchangeResult = await exchange(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      fromAmount: amount,
    );
    return exchangeResult.toAmount;
  }
}
