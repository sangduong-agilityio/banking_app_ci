import 'dart:async';
import 'package:banking_app/features/chat/models/chat_message.dart';
import 'package:banking_app/features/chat/repositories/assistant_repository.dart';
import 'package:banking_app/features/chat/services/ag_ui_service.dart';

/// Mock implementation of AssistantRepository for testing
class MockAssistantRepository implements AssistantRepository {
  final List<ChatMessage> _messages = [];
  final StreamController<AgUiEvent> _eventController = StreamController<AgUiEvent>.broadcast();
  bool _isConnected = false;

  @override
  Stream<AgUiEvent>? get events => _eventController.stream;

  @override
  Future<void> clearChatHistory() async {
    _messages.clear();
  }

  @override
  Future<void> connect() async {
    if (!_isConnected) {
      _isConnected = true;
      _eventController.add(
        AgUiEvent(
          type: AgUiEventType.runStarted,
          data: {'run_id': 'mock_run_1'},
        ),
      );
    }
  }

  @override
  void disconnect() {
    _isConnected = false;
    _eventController.add(
      AgUiEvent(
        type: AgUiEventType.runFinished,
        data: {'run_id': 'mock_run_1'},
      ),
    );
  }

  @override
  Future<List<ChatMessage>> loadChatHistory() async {
    return List.from(_messages);
  }

  @override
  Future<void> saveChatHistory(List<ChatMessage> messages) async {
    _messages
      ..clear()
      ..addAll(messages);
  }

  @override
  Future<void> sendMessage(ChatMessage message) async {
    _messages.add(message);

    // Simulate assistant response after a short delay
    Timer(const Duration(milliseconds: 500), () {
      _eventController.add(
        AgUiEvent(
          type: AgUiEventType.textChunk,
          data: {
            'text': 'This is a mock response to: ${message.content}',
          },
        ),
      );
    });
  }

  @override
  Future<void> sendToolResult(String toolCallId, String result) async {
    _eventController.add(
      AgUiEvent(
        type: AgUiEventType.runFinished,
        data: {
          'run_id': 'mock_run_1',
          'tool_call_id': toolCallId,
          'result': result,
        },
      ),
    );
  }

  /// Close the mock event stream
  void dispose() {
    _eventController.close();
  }
}