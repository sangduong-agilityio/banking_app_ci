import 'package:freezed_annotation/freezed_annotation.dart';

part 'tool_models.freezed.dart';
part 'tool_models.g.dart';

/// Defines a tool that can be used by the AI agent
@freezed
class ToolDefinition with _$ToolDefinition {
  const factory ToolDefinition({
    required String name,
    required String description,
    required Map<String, dynamic> parameters,
    @Default(false) bool isAuthenticated,
  }) = _ToolDefinition;

  factory ToolDefinition.fromJson(Map<String, dynamic> json) =>
      _$ToolDefinitionFromJson(json);
}

/// Status of a tool execution
enum ToolCallStatus {
  pending,
  running,
  completed,
  failed,
}

/// Model to track tool execution status and results
@freezed
class ToolCall with _$ToolCall {
  const factory ToolCall({
    required String id,
    required String toolName,
    required Map<String, dynamic> arguments,
    required ToolCallStatus status,
    String? result,
    String? error,
    DateTime? startTime,
    DateTime? endTime,
  }) = _ToolCall;

  factory ToolCall.fromJson(Map<String, dynamic> json) =>
      _$ToolCallFromJson(json);
}