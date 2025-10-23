import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/chat_message.dart';
import '../models/tool_models.dart';

part 'assistant_state.freezed.dart';

@freezed
class AssistantState with _$AssistantState {
  const factory AssistantState.initial() = Initial;
  
  const factory AssistantState.connecting() = Connecting;
  
  const factory AssistantState.connected({
    required List<ChatMessage> messages,
  }) = Connected;
  
  const factory AssistantState.messageSending({
    required List<ChatMessage> messages,
    required String pendingMessage,
  }) = MessageSending;
  
  const factory AssistantState.streaming({
    required List<ChatMessage> messages,
    required String currentResponse,
  }) = Streaming;
  
  const factory AssistantState.toolCallRequested({
    required List<ChatMessage> messages,
    required ToolCall toolCall,
  }) = ToolCallRequested;
  
  const factory AssistantState.error({
    required String message,
    required List<ChatMessage> messages,
  }) = Error;
}