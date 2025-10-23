import 'package:flutter/material.dart';
import '../tools/tool_handler.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/account/presentation/blocs/account_and_card_cubit.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';

class FetchBalanceFromAssistantTool extends ToolHandler {
  @override
  String get toolName => 'fetch_balance';

  @override
  bool get requiresConfirmation => false;

  @override
  String getConfirmationMessage(Map<String, dynamic> arguments) => '';

  @override
  Future<bool> showConfirmation(BuildContext context, Map<String, dynamic> arguments) async {
    return true;
  }

  @override
  Future<Map<String, dynamic>> execute(BuildContext context, Map<String, dynamic> arguments) async {
    print('FetchBalanceFromAssistantTool executing with arguments: $arguments');
    final accountNumber = arguments['accountNumber'] as String?;
    
    if (accountNumber == null) {
      if (context.mounted) {
        BASnackBar.buildErrorSnackbar(
          context,
          'Please provide an account number',
        );
      }
      return {
        'success': false,
        'message': 'Account number is required',
      };
    }

    // Get the AccountAndCardCubit instance and ensure it's initialized
    final accountCubit = locator<AccountAndCardCubit>();
    if (accountCubit.state.accounts.isEmpty) {
      await accountCubit.accountAndCardInitialize();
    }

    try {
      // Get the AccountAndCardCubit instance
      final accountCubit = locator<AccountAndCardCubit>();
      
      // Debug prints
      print('Account number to find: $accountNumber');
      print('Available accounts: ${accountCubit.state.accounts.map((a) => a.accountNumber).toList()}');
      
      // Find account by account number
      final account = accountCubit.state.accounts.firstWhere(
        (account) => account.accountNumber == accountNumber,
        orElse: () => throw Exception('Account not found'),
      );
      
      // Fetch balance for the account
      final balance = account.availableBalance;
      
      // Show balance in a snackbar
      if (context.mounted) {
        BASnackBar.buildSuccessSnackbar(
          context,
          '💰 Balance for account $accountNumber is \$${balance.toStringAsFixed(2)}',
        );
      }

      return {
        'success': true,
        'balance': balance,
        'message': '💰 Your balance is \$${balance.toStringAsFixed(2)}',
      };
    } catch (e) {
      if (context.mounted) {
        BASnackBar.buildErrorSnackbar(
          context,
          'Unable to fetch balance: ${e.toString()}',
        );
      }
      return {
        'success': false,
        'message': 'Unable to fetch balance: ${e.toString()}',
      };
    }
  }
}