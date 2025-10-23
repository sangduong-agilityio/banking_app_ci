import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';
import '../services/ag_ui_service.dart';

/// Key for storing chat history in SharedPreferences
const String _chatHistoryKey = 'chat_history';

/// Abstract base class for the assistant repository
abstract class AssistantRepository {
  Stream<AgUiEvent>? get events;
  Future<List<ChatMessage>> loadChatHistory();
  Future<void> saveChatHistory(List<ChatMessage> messages);
  Future<void> clearChatHistory();
  Future<void> sendMessage(ChatMessage message);
  Future<void> sendToolResult(String toolCallId, String result);
  Future<void> connect();
  void disconnect();
}

/// Implementation of the AssistantRepository
class AssistantRepositoryImpl implements AssistantRepository {
  final AgUiService _agUiService;
  final SharedPreferences _prefs;

  AssistantRepositoryImpl({
    required AgUiService agUiService,
    required SharedPreferences prefs,
  })  : _agUiService = agUiService,
        _prefs = prefs;

  @override
  Stream<AgUiEvent>? get events => _agUiService.events;

  @override
  Future<List<ChatMessage>> loadChatHistory() async {
    final jsonString = _prefs.getString(_chatHistoryKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => ChatMessage.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If there's an error loading history, return empty list
      return [];
    }
  }

  @override
  Future<void> saveChatHistory(List<ChatMessage> messages) async {
    final jsonString = jsonEncode(
      messages.map((msg) => msg.toJson()).toList(),
    );
    await _prefs.setString(_chatHistoryKey, jsonString);
  }

  @override
  Future<void> clearChatHistory() async {
    await _prefs.remove(_chatHistoryKey);
  }

  @override
  Future<void> sendMessage(ChatMessage message) async {
    await _agUiService.sendMessage(message);
    
    // Load existing history
    final history = await loadChatHistory();
    
    // Add new message and save
    history.add(message);
    await saveChatHistory(history);
  }

  @override
  Future<void> sendToolResult(String toolCallId, String result) async {
    await _agUiService.sendToolResult(toolCallId, result);
  }

  @override
  Future<void> connect() => _agUiService.connect();

  @override
  void disconnect() => _agUiService.disconnect();
}