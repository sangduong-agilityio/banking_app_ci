import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:banking_app/app/router/app_router.dart';
import 'package:banking_app/features/chat/tools/tool_handler.dart';
import 'package:banking_app/features/transfer/data/models/transfer_params.dart';

class OpenTransferScreenTool extends ToolHandler {
  @override
  String get toolName => 'open_transfer_screen';

  @override
  bool get requiresConfirmation => false;

  @override
  String getConfirmationMessage(Map<String, dynamic> arguments) =>
      'Do you want to open the transfer screen?';

  @override
  Future<bool> showConfirmation(BuildContext context, Map<String, dynamic> arguments) async {
    return true;  // No confirmation needed for navigation
  }

  @override
  Future<Map<String, dynamic>> execute(BuildContext context, Map<String, dynamic> arguments) async {
    final params = TransferParams.fromJson(arguments);
    
    // Navigate and wait for result
    final result = await Navigator.pushNamed(context, BAPaths.transfer.path, arguments: params);
    
    return {
      'success': true,
      'message': '✅ Transfer screen opened${result != null ? ' with result: $result' : ''}',
    };
  }
}