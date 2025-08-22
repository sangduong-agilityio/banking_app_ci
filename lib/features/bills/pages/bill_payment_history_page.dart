import 'package:banking_app/features/bills/models/bill_model.dart';
import 'package:banking_app/features/bills/models/payment_history_model.dart';
import 'package:flutter/material.dart';

class PaymentHistoryScreen extends StatelessWidget {
  final List<BillModel> bills;

  const PaymentHistoryScreen({super.key, required this.bills});

  @override
  Widget build(BuildContext context) {
    final availableTypes = bills.map((b) => b.billType).toSet().toList();

    return DefaultTabController(
      length: availableTypes.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Payment history',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
        body: Column(
          children: [
            TabBar(
              indicatorColor: Color(0xFF4C7CE5),
              labelColor: Color(0xFF4C7CE5),
              unselectedLabelColor: Colors.grey,
              isScrollable: true,
              tabs: availableTypes
                  .map((type) => Tab(text: _capitalize(type.name)))
                  .toList(),
            ),
            Expanded(
              child: TabBarView(
                children: availableTypes
                    .map((type) => _buildHistoryList(type))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  Widget _buildHistoryList(BillType billType) {
    // Generate sample payment history for the bill type
    final paymentHistory = _generatePaymentHistory(billType);

    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: paymentHistory.length,
      itemBuilder: (context, index) {
        final history = paymentHistory[index];
        return Container(
          margin: EdgeInsets.only(bottom: 15),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatMonthYear(history.paymentDate),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    _formatDate(history.paymentDate),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    history.status.displayName,
                    style: TextStyle(fontSize: 14, color: history.status.color),
                  ),
                  Text(
                    '\${history.amount.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                'Company: ${history.providerName}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              if (history.transactionId != null) ...[
                SizedBox(height: 5),
                Text(
                  'Transaction ID: ${history.transactionId}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  List<PaymentHistoryModel> _generatePaymentHistory(BillType billType) {
    final now = DateTime.now();
    final providerName = _getProviderName(billType);
    final baseAmount = _getBaseAmount(billType);

    return List.generate(5, (index) {
      final paymentDate = DateTime(now.year, now.month - index, 15);
      return PaymentHistoryModel(
        id: 'payment_${billType.name}_$index',
        billId: 'bill_${billType.name}',
        userId: 'user123',
        amount: baseAmount + (index * 5),
        paymentDate: paymentDate,
        status: PaymentStatus.successful,
        providerName: providerName,
        transactionId: 'TXN${DateTime.now().millisecondsSinceEpoch + index}',
      );
    });
  }

  String _getProviderName(BillType billType) {
    switch (billType) {
      case BillType.electric:
        return 'Electric Company';
      case BillType.water:
        return 'Water Authority';
      case BillType.internet:
        return 'Fage Telecom';
    }
  }

  double _getBaseAmount(BillType billType) {
    switch (billType) {
      case BillType.electric:
        return 450.0;
      case BillType.water:
        return 85.0;
      case BillType.internet:
        return 50.0;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
