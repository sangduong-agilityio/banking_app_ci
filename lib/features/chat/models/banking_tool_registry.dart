import 'package:banking_app/features/chat/models/tool_models.dart';

/// Registry containing all available banking tools
class BankingToolRegistry {
  /// Get all available banking tools
  static List<ToolDefinition> getTools() {
    return [
      ToolDefinition(
        name: 'OpenTransferScreen',
        description: 'Opens the money transfer screen',
        parameters: {
          'amount': {'type': 'number', 'description': 'Amount to transfer'},
          'recipient': {'type': 'string', 'description': 'Recipient account or name'},
        },
      ),
      
      ToolDefinition(
        name: 'FetchAccountBalance',
        description: 'Retrieves current account balance',
        parameters: {
          'accountId': {'type': 'string', 'description': 'ID of the account to check'},
        },
      ),
      
      ToolDefinition(
        name: 'LockCard',
        description: 'Temporarily locks a card',
        parameters: {
          'cardId': {'type': 'string', 'description': 'ID of the card to lock'},
        },
      ),
      
      ToolDefinition(
        name: 'UnlockCard',
        description: 'Unlocks a previously locked card',
        parameters: {
          'cardId': {'type': 'string', 'description': 'ID of the card to unlock'},
        },
      ),
      
      ToolDefinition(
        name: 'FetchTransactionHistory',
        description: 'Retrieves transaction history',
        parameters: {
          'accountId': {'type': 'string', 'description': 'Account ID'},
          'startDate': {'type': 'string', 'description': 'Start date (YYYY-MM-DD)'},
          'endDate': {'type': 'string', 'description': 'End date (YYYY-MM-DD)'},
        },
      ),
      
      ToolDefinition(
        name: 'OpenBillPayment',
        description: 'Opens the bill payment screen',
        parameters: {
          'billType': {'type': 'string', 'description': 'Type of bill (utility, credit, etc.)'},
          'amount': {'type': 'number', 'description': 'Amount to pay'},
        },
      ),
      
      ToolDefinition(
        name: 'SearchTransactions',
        description: 'Search transactions by various criteria',
        parameters: {
          'query': {'type': 'string', 'description': 'Search query (merchant, amount, etc.)'},
          'startDate': {'type': 'string', 'description': 'Start date (YYYY-MM-DD)', 'optional': true},
          'endDate': {'type': 'string', 'description': 'End date (YYYY-MM-DD)', 'optional': true},
        },
      ),
    ];
  }

  /// Get a specific tool by name
  static ToolDefinition? getTool(String name) {
    return getTools().firstWhere(
      (tool) => tool.name == name,
      orElse: () => throw Exception('Tool not found: $name'),
    );
  }

  /// Check if a tool exists
  static bool hasTool(String name) {
    return getTools().any((tool) => tool.name == name);
  }
}