import 'package:flutter/material.dart';

abstract class ToolHandler {
  String get toolName;
  
  /// Returns true if the tool execution requires user confirmation
  bool get requiresConfirmation;
  
  /// Executes the tool and returns the result
  Future<dynamic> execute(BuildContext context, Map<String, dynamic> params);
  
  /// Shows a confirmation dialog if required
  /// Returns true if the user confirms, false otherwise
  Future<bool> showConfirmation(BuildContext context, Map<String, dynamic> params) async {
    if (!requiresConfirmation) return true;
    
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm ${toolName}'),
        content: Text(getConfirmationMessage(params)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    ) ?? false;
  }
  
  /// Gets the confirmation message to show to the user
  String getConfirmationMessage(Map<String, dynamic> params);
}