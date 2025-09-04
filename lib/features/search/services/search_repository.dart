import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/search_model.dart';

class SearchRepository {
  static const String _baseUrl = "https://api.exchangerate-api.com/v4/latest";

  Future<List<ExchangeRate>> fetchExchangeRates(String baseCurrency) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/$baseCurrency"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Map<String, dynamic> rates = data['rates'];

        Map<String, Map<String, String>> currencies = {
          'VND': {'country': 'Vietnam', 'flag': '🇻🇳'},
          'EUR': {'country': 'European Union', 'flag': '🇪🇺'},
          'GBP': {'country': 'United Kingdom', 'flag': '🇬🇧'},
          'JPY': {'country': 'Japan', 'flag': '🇯🇵'},
          'CNY': {'country': 'China', 'flag': '🇨🇳'},
          'KRW': {'country': 'South Korea', 'flag': '🇰🇷'},
          'RUB': {'country': 'Russia', 'flag': '🇷🇺'},
          'CAD': {'country': 'Canada', 'flag': '🇨🇦'},
          'AUD': {'country': 'Australia', 'flag': '🇦🇺'},
          'SGD': {'country': 'Singapore', 'flag': '🇸🇬'},
        };

        List<ExchangeRate> exchangeRates = [];
        currencies.forEach((code, info) {
          if (rates[code] != null) {
            final rate = rates[code].toDouble();
            exchangeRates.add(
              ExchangeRate.fromApi(code, info['country']!, info['flag']!, rate),
            );
          }
        });

        return exchangeRates;
      } else {
        throw Exception("Failed to load exchange rates");
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  /// Convert currency
  Future<double> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/$fromCurrency"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rate = (data['rates'][toCurrency] ?? 1).toDouble();
        return amount * rate;
      } else {
        throw Exception("Failed to convert currency");
      }
    } catch (e) {
      print("Error: $e");
      return 0;
    }
  }

  Future<List<InterestRate>> fetchInterestRates() async {
    await Future.delayed(Duration(milliseconds: 500));
    return [
      InterestRate(type: "Individual customers", period: "1m", rate: "4.50%"),
      InterestRate(type: "Individual customers", period: "2m", rate: "4.75%"),
      InterestRate(type: "Individual customers", period: "12m", rate: "5.00%"),
      InterestRate(type: "Corporate customers", period: "1m", rate: "3.50%"),
      InterestRate(type: "Corporate customers", period: "2m", rate: "3.75%"),
      InterestRate(type: "Corporate customers", period: "12m", rate: "4.00%"),
    ];
  }

  Future<SearchModel> fetchSearchData(String baseCurrency) async {
    final exchangeRates = await fetchExchangeRates(baseCurrency);
    final interestRates = await fetchInterestRates();

    // dummy transactions
    final transactions = [
      ExchangeTransaction(
        fromCurrency: "USD",
        toCurrency: "VND",
        fromAmount: 100,
        toAmount: 2430000,
        time: DateTime.now().subtract(Duration(hours: 2)),
      ),
      ExchangeTransaction(
        fromCurrency: "EUR",
        toCurrency: "USD",
        fromAmount: 50,
        toAmount: 59,
        time: DateTime.now().subtract(Duration(days: 1)),
      ),
    ];

    return SearchModel(
      exchangeRates: exchangeRates,
      transactions: transactions,
      interestRates: interestRates,
    );
  }
}
