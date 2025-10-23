import 'package:banking_app/features/chat/tools/tool_handler.dart';
import 'package:flutter/material.dart';

export 'fetch_balance_tool.dart';
export 'tool_handler.dart';
export 'open_transfer_screen_tool.dart';

class OpenTransferScreenHandler extends ToolHandler {
  @override
  String get toolName => 'openTransferScreen';

  @override
  bool get requiresConfirmation => false;

  @override
  Future<dynamic> execute(BuildContext context, Map<String, dynamic> params) async {
    final amount = params['amount'] as double?;
    final recipient = params['recipient'] as String?;
    
    // Navigate to transfer screen with pre-filled data
    Navigator.of(context).pushNamed(
      '/transfer',
      arguments: {
        'amount': amount,
        'recipient': recipient,
      },
    );
    
    return true;
  }

  @override
  String getConfirmationMessage(Map<String, dynamic> params) => '';
}

class FetchAccountBalanceHandler extends ToolHandler {
  @override
  String get toolName => 'fetchAccountBalance';

  @override
  bool get requiresConfirmation => false;

  @override
  Future<dynamic> execute(BuildContext context, Map<String, dynamic> params) async {
    // If a callback is provided in params, use it; otherwise return a stub.
    final getBalance = params['getBalance'] as Future<double> Function()?;
    if (getBalance != null) {
      final balance = await getBalance();
      return {'balance': balance};
    }
    return {'balance': 0.0};
  }

  @override
  String getConfirmationMessage(Map<String, dynamic> params) => '';
}

class LockCardHandler extends ToolHandler {
  @override
  String get toolName => 'lockCard';

  @override
  bool get requiresConfirmation => true;

  @override
  Future<dynamic> execute(BuildContext context, Map<String, dynamic> params) async {
    final lockCallback = params['lockCard'] as Future<void> Function(String)?;
    final cardId = params['cardId'] as String?;
    if (lockCallback != null && cardId != null) {
      await lockCallback(cardId);
      return true;
    }
    throw Exception('lockCard handler not provided');
  }

  @override
  String getConfirmationMessage(Map<String, dynamic> params) {
    return 'Are you sure you want to lock your card? This will prevent all future transactions until you unlock it.';
  }
}

class FetchTransactionHistoryHandler extends ToolHandler {
  @override
  String get toolName => 'fetchTransactionHistory';

  @override
  bool get requiresConfirmation => false;

  @override
  Future<dynamic> execute(BuildContext context, Map<String, dynamic> params) async {
    final getTransactions = params['getTransactions'] as Future<List<dynamic>> Function({DateTime? startDate, DateTime? endDate})?;
    final startDate = params['startDate'] as DateTime?;
    final endDate = params['endDate'] as DateTime?;
    if (getTransactions != null) {
      final transactions = await getTransactions(startDate: startDate, endDate: endDate);
      return {'transactions': transactions};
    }
    return {'transactions': []};
  }

  @override
  String getConfirmationMessage(Map<String, dynamic> params) => '';
}