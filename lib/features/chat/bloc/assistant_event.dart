import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/tool_models.dart';

part 'assistant_event.freezed.dart';

@freezed
class AssistantEvent with _$AssistantEvent {
  const factory AssistantEvent.initialize() = InitializeEvt;
  
  const factory AssistantEvent.sendMessage({
    required String message,
  }) = SendMessageEvt;
  
  const factory AssistantEvent.textChunkReceived({
    required String text,
  }) = TextChunkReceivedEvt;
  
  const factory AssistantEvent.toolCallReceived({
    required ToolCall toolCall,
  }) = ToolCallReceivedEvt;
  
  const factory AssistantEvent.toolExecuted({
    required String toolName,
    required dynamic result,
  }) = ToolExecutedEvt;
  
  const factory AssistantEvent.loadHistory() = LoadHistoryEvt;
  
  const factory AssistantEvent.clearHistory() = ClearHistoryEvt;
}