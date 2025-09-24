import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/transactions/models/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionReportScreen extends StatelessWidget {
  const TransactionReportScreen({super.key, this.transactions});

  final List<TransactionModel>? transactions;
  @override
  Widget build(BuildContext context) {
    return BAScaffold(body: Text('Transaction Report Screen'));
  }
}
