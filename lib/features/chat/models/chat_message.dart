import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

/// Represents different types of chat messages
enum ChatMessageType {
  user,
  assistant,
  system,
  tool,
}

/// Status of a message
enum MessageStatus {
  sending,
  sent,
  error,
}

/// Base chat message model
@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String content,
    required ChatMessageType type,
    DateTime? timestamp,
      MessageStatus? status,
      String? error,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  /// Create a user message
  factory ChatMessage.user({
    required String id,
    required String content,
    DateTime? timestamp,
  }) =>
      ChatMessage(
        id: id,
        content: content,
        type: ChatMessageType.user,
        timestamp: timestamp ?? DateTime.now(),
      );

  /// Create an assistant message
  factory ChatMessage.assistant({
    required String id,
    required String content,
    DateTime? timestamp,
  }) =>
      ChatMessage(
        id: id,
        content: content,
        type: ChatMessageType.assistant,
        timestamp: timestamp ?? DateTime.now(),
      );

  /// Create a system message
  factory ChatMessage.system({
    required String id,
    required String content,
    DateTime? timestamp,
  }) =>
      ChatMessage(
        id: id,
        content: content,
        type: ChatMessageType.system,
        timestamp: timestamp ?? DateTime.now(),
      );

  /// Create a tool message
  factory ChatMessage.tool({
    required String id,
    required String content,
    DateTime? timestamp,
  }) =>
      ChatMessage(
        id: id,
        content: content,
        type: ChatMessageType.tool,
        timestamp: timestamp ?? DateTime.now(),
      );
}