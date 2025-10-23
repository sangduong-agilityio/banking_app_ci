import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
// http package not required in this service currently

import '../models/chat_message.dart';

/// Event types from AG-UI backend
enum AgUiEventType {
  runStarted,
  textChunk,
  toolCall,
  runFinished,
  error,
}

/// Event from AG-UI backend
class AgUiEvent {
  final AgUiEventType type;
  final Map<String, dynamic> data;

  AgUiEvent({required this.type, required this.data});

  factory AgUiEvent.fromJson(Map<String, dynamic> json) {
    return AgUiEvent(
      type: AgUiEventType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => AgUiEventType.error,
      ),
      data: json['data'] as Map<String, dynamic>,
    );
  }
}

/// Service for interacting with AG-UI backend
class AgUiService {
  final String baseUrl;
  final String? apiKey;
  WebSocketChannel? _channel;
  StreamController<AgUiEvent>? _eventController;
  Timer? _reconnectTimer;
  bool _isConnected = false;

  AgUiService({
    required this.baseUrl,
    this.apiKey,
  });

  /// Stream of events from the backend
  Stream<AgUiEvent>? get events => _eventController?.stream;

  /// Connect to the AG-UI backend
  Future<void> connect() async {
    if (_isConnected) return;

    try {
      final wsUrl = Uri.parse(baseUrl.replaceFirst(
        RegExp(r'^http(s)?://'),
        'ws\$1://',
      ));

      _channel = WebSocketChannel.connect(wsUrl);
      _eventController = StreamController<AgUiEvent>.broadcast();

      _channel!.stream.listen(
        (data) => _handleMessage(data as String),
        onError: _handleError,
        onDone: _handleDisconnect,
        cancelOnError: false,
      );

      _isConnected = true;
    } catch (e) {
      _handleError(e);
    }
  }

  /// Disconnect from the backend
  void disconnect() {
    _channel?.sink.close();
    _eventController?.close();
    _reconnectTimer?.cancel();
    _isConnected = false;
  }

  /// Send a message to the backend
  Future<void> sendMessage(ChatMessage message) async {
    if (!_isConnected) {
      await connect();
    }

    final payload = {
      'type': 'message',
      'data': {
        'id': message.id,
        'content': message.content,
        'role': message.type.toString().split('.').last,
      },
    };

    _channel?.sink.add(jsonEncode(payload));
  }

  /// Send tool result back to backend
  Future<void> sendToolResult(String toolCallId, String result) async {
    if (!_isConnected) {
      await connect();
    }

    final payload = {
      'type': 'tool_result',
      'data': {
        'tool_call_id': toolCallId,
        'result': result,
      },
    };

    _channel?.sink.add(jsonEncode(payload));
  }

  /// Handle incoming message from backend
  void _handleMessage(String message) {
    try {
      final data = jsonDecode(message) as Map<String, dynamic>;
      final event = AgUiEvent.fromJson(data);
      _eventController?.add(event);
    } catch (e) {
      _handleError(e);
    }
  }

  /// Handle WebSocket errors
  void _handleError(dynamic error) {
    _eventController?.addError(error);
    _handleDisconnect();
  }

  /// Handle WebSocket disconnection
  void _handleDisconnect() {
    _isConnected = false;
    _channel?.sink.close();
    _channel = null;

    // Attempt to reconnect after delay
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (!_isConnected) {
        connect();
      }
    });
  }

  // HTTP helper removed (unused). Use specific API calls on-demand.
}