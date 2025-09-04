import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({super.key});

  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'VND';
  double _exchangeRate = 24300.0;
  double _convertedAmount = 0.0;

  final List<Map<String, String>> _currencies = [
    {'code': 'USD', 'name': 'US Dollar', 'flag': '🇺🇸'},
    {'code': 'VND', 'name': 'Vietnamese Dong', 'flag': '🇻🇳'},
    {'code': 'EUR', 'name': 'Euro', 'flag': '🇪🇺'},
    {'code': 'GBP', 'name': 'British Pound', 'flag': '🇬🇧'},
    {'code': 'JPY', 'name': 'Japanese Yen', 'flag': '🇯🇵'},
    {'code': 'CNY', 'name': 'Chinese Yuan', 'flag': '🇨🇳'},
    {'code': 'KRW', 'name': 'Korean Won', 'flag': '🇰🇷'},
  ];

  @override
  void initState() {
    super.initState();
    _loadExchangeRate();
  }

  Future<void> _loadExchangeRate() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/$_fromCurrency'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['rates'][_toCurrency] != null) {
          setState(() {
            _exchangeRate = data['rates'][_toCurrency].toDouble();
          });
          _convertCurrency();
        }
      }
    } catch (e) {
      print("Error loading exchange rate: $e");
      // Use default rates
      _setDefaultRate();
    }
  }

  void _setDefaultRate() {
    Map<String, Map<String, double>> defaultRates = {
      'USD': {
        'VND': 24300,
        'EUR': 0.85,
        'GBP': 0.75,
        'JPY': 149,
        'CNY': 7.3,
        'KRW': 1330,
      },
      'VND': {'USD': 0.000041, 'EUR': 0.000035, 'GBP': 0.000031},
      'EUR': {'USD': 1.18, 'VND': 28600, 'GBP': 0.88},
    };

    if (defaultRates[_fromCurrency] != null &&
        defaultRates[_fromCurrency]![_toCurrency] != null) {
      setState(() {
        _exchangeRate = defaultRates[_fromCurrency]![_toCurrency]!;
      });
    } else {
      setState(() {
        _exchangeRate = 1.0;
      });
    }
    _convertCurrency();
  }

  void _convertCurrency() {
    if (_amountController.text.isNotEmpty) {
      double amount = double.tryParse(_amountController.text) ?? 0;
      setState(() {
        _convertedAmount = amount * _exchangeRate;
      });
    }
  }

  void _swapCurrencies() {
    setState(() {
      String temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _exchangeRate = 1 / _exchangeRate;
    });
    _convertCurrency();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Exchange',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // From Currency Card
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'From',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showCurrencySelector(true),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currencies.firstWhere(
                                  (c) => c['code'] == _fromCurrency,
                                )['flag']!,
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(width: 8),
                              Text(
                                _fromCurrency,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: '0.00',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 24,
                            ),
                          ),
                          onChanged: (value) {
                            _convertCurrency();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Swap Button
            Center(
              child: GestureDetector(
                onTap: _swapCurrencies,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(Icons.swap_vert, color: Colors.white, size: 24),
                ),
              ),
            ),

            SizedBox(height: 16),

            // To Currency Card
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'To',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showCurrencySelector(false),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currencies.firstWhere(
                                  (c) => c['code'] == _toCurrency,
                                )['flag']!,
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(width: 8),
                              Text(
                                _toCurrency,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          _convertedAmount.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Exchange Rate Info
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '1 $_fromCurrency = ${_exchangeRate.toStringAsFixed(4)} $_toCurrency',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    'Live rate',
                    style: TextStyle(fontSize: 12, color: Colors.blue[600]),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Exchange Button
            Container(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _amountController.text.isNotEmpty
                    ? _performExchange
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Exchange Now',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Recent Exchanges (placeholder)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Exchanges',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildRecentExchangeItem(
                          'USD',
                          'VND',
                          '100',
                          '2,430,000',
                          '2 hours ago',
                        ),
                        _buildRecentExchangeItem(
                          'EUR',
                          'USD',
                          '50',
                          '59',
                          'Yesterday',
                        ),
                        _buildRecentExchangeItem(
                          'GBP',
                          'VND',
                          '25',
                          '760,000',
                          '3 days ago',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentExchangeItem(
    String from,
    String to,
    String fromAmount,
    String toAmount,
    String time,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.swap_horiz, color: Colors.green, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$fromAmount $from → $toAmount $to',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: Colors.green, size: 20),
        ],
      ),
    );
  }

  void _showCurrencySelector(bool isFromCurrency) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Currency',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              ...(_currencies.map((currency) {
                return ListTile(
                  leading: Text(
                    currency['flag']!,
                    style: TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    currency['name']!,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(currency['code']!),
                  onTap: () {
                    setState(() {
                      if (isFromCurrency) {
                        _fromCurrency = currency['code']!;
                      } else {
                        _toCurrency = currency['code']!;
                      }
                    });
                    Navigator.pop(context);
                    _loadExchangeRate();
                  },
                );
              }).toList()),
            ],
          ),
        );
      },
    );
  }

  void _performExchange() {
    // Implement exchange logic here
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exchange Confirmation'),
        content: Text(
          'Exchange ${_amountController.text} $_fromCurrency to ${_convertedAmount.toStringAsFixed(2)} $_toCurrency?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessDialog();
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Success'),
          ],
        ),
        content: Text('Exchange completed successfully!'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
