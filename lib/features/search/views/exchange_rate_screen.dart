import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ExchangeRateScreen extends StatefulWidget {
  const ExchangeRateScreen({super.key});

  @override
  State<ExchangeRateScreen> createState() => _ExchangeRateScreenState();
}

class _ExchangeRateScreenState extends State<ExchangeRateScreen> {
  List<Map<String, dynamic>> _rates = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExchangeRates();
  }

  Future<void> _loadExchangeRates() async {
    try {
      // Using a free currency API (replace with your preferred API)
      final response = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Map<String, dynamic>> rates = [];

        // Popular currencies with their country info
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

        currencies.forEach((code, info) {
          if (data['rates'][code] != null) {
            double rate = data['rates'][code].toDouble();
            rates.add({
              'country': info['country']!,
              'flag': info['flag']!,
              'code': code,
              'buy': (rate * 0.98).toStringAsFixed(
                3,
              ), // Buy rate (slightly lower)
              'sell': (rate * 1.02).toStringAsFixed(
                3,
              ), // Sell rate (slightly higher)
            });
          }
        });

        setState(() {
          _rates = rates;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading exchange rates: $e");
      _loadDummyRates();
    }
  }

  void _loadDummyRates() {
    setState(() {
      _rates = [
        {
          'country': 'Vietnam',
          'flag': '🇻🇳',
          'code': 'VND',
          'buy': '24,100',
          'sell': '24,500',
        },
        {
          'country': 'European Union',
          'flag': '🇪🇺',
          'code': 'EUR',
          'buy': '0.850',
          'sell': '0.870',
        },
        {
          'country': 'United Kingdom',
          'flag': '🇬🇧',
          'code': 'GBP',
          'buy': '0.750',
          'sell': '0.780',
        },
        {
          'country': 'Japan',
          'flag': '🇯🇵',
          'code': 'JPY',
          'buy': '148.50',
          'sell': '150.20',
        },
        {
          'country': 'China',
          'flag': '🇨🇳',
          'code': 'CNY',
          'buy': '7.250',
          'sell': '7.350',
        },
        {
          'country': 'South Korea',
          'flag': '🇰🇷',
          'code': 'KRW',
          'buy': '1,320',
          'sell': '1,350',
        },
        {
          'country': 'Russia',
          'flag': '🇷🇺',
          'code': 'RUB',
          'buy': '95.50',
          'sell': '98.20',
        },
        {
          'country': 'Canada',
          'flag': '🇨🇦',
          'code': 'CAD',
          'buy': '1.350',
          'sell': '1.380',
        },
        {
          'country': 'Australia',
          'flag': '🇦🇺',
          'code': 'AUD',
          'buy': '1.520',
          'sell': '1.560',
        },
        {
          'country': 'Singapore',
          'flag': '🇸🇬',
          'code': 'SGD',
          'buy': '1.340',
          'sell': '1.370',
        },
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Exchange rate',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.blue),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadExchangeRates();
            },
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Country',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Buy',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Sell',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadExchangeRates,
                    child: ListView.builder(
                      itemCount: _rates.length,
                      itemBuilder: (context, index) {
                        return _buildExchangeRateItem(_rates[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeRateItem(Map<String, dynamic> rate) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Text(rate['flag'], style: TextStyle(fontSize: 20)),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rate['country'],
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Text(
                        rate['code'],
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              rate['buy'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              rate['sell'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
