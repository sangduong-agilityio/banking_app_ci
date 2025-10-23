import 'tool_handler.dart';
import 'handlers.dart';
import 'fetch_balance_tool.dart';

class ToolRegistry {
  static final Map<String, ToolHandler> _handlers = {
    'openTransferScreen': OpenTransferScreenHandler(),
    'fetch_balance': FetchBalanceFromAssistantTool(),
    'lockCard': LockCardHandler(),
    'fetchTransactionHistory': FetchTransactionHistoryHandler(),
  };

  static ToolHandler? getHandler(String toolName) {
    print('Getting handler for tool: $toolName');
    print('Available tools: ${_handlers.keys.toList()}');
    return _handlers[toolName];
  }

  static List<String> get availableTools => _handlers.keys.toList();
}