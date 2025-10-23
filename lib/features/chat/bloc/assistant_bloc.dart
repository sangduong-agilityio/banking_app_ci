import 'dart:async';

import '../models/chat_message.dart';
import '../models/tool_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/assistant_repository.dart';
import '../services/ag_ui_service.dart';
import 'assistant_event.dart';
import 'assistant_state.dart';

class AssistantBloc extends Bloc<AssistantEvent, AssistantState> {
  final AgUiService _agUiService;
  final AssistantRepository _repository;
  StreamSubscription<AgUiEvent>? _eventSubscription;

  AssistantBloc({
    required AgUiService agUiService,
    required AssistantRepository repository,
  })  : _agUiService = agUiService,
        _repository = repository,
        super(const AssistantState.initial()) {
    on<InitializeEvt>(_onInitialize);
    on<SendMessageEvt>(_onSendMessage);
    on<TextChunkReceivedEvt>(_onTextChunkReceived);
    on<ToolCallReceivedEvt>(_onToolCallReceived);
    on<ToolExecutedEvt>(_onToolExecuted);
    on<LoadHistoryEvt>(_onLoadHistory);
    on<ClearHistoryEvt>(_onClearHistory);

    // Subscribe to AG-UI service events
    _eventSubscription = _agUiService.events?.listen(_handleServiceEvent);
  }

  Future<void> _onInitialize(InitializeEvt event, Emitter<AssistantState> emit) async {
    emit(const AssistantState.connecting());
    try {
      await _repository.connect();
      final history = await _repository.loadChatHistory();
      emit(AssistantState.connected(messages: history));
    } catch (e) {
      emit(AssistantState.error(message: 'Failed to connect: $e', messages: []));
    }
  }

  Future<void> _onSendMessage(SendMessageEvt event, Emitter<AssistantState> emit) async {
    final currentState = state;
    List<ChatMessage> messages = _extractMessages(currentState);

    // Create message with an id
    final newMessage = ChatMessage.user(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      content: event.message,
    );

    emit(AssistantState.messageSending(
      messages: [...messages, newMessage],
      pendingMessage: event.message,
    ));

    try {
      await _repository.sendMessage(newMessage);
      // After successfully sending, emit connected with updated messages
      final sent = newMessage.copyWith(status: MessageStatus.sent);
      messages = [...messages, sent];
      emit(AssistantState.connected(messages: messages));
    } catch (e) {
      // mark message as error
      final failed = newMessage.copyWith(status: MessageStatus.error, error: e.toString());
      emit(AssistantState.error(
        message: 'Failed to send message: $e',
        messages: [...messages, failed],
      ));
    }
  }

  void _onTextChunkReceived(TextChunkReceivedEvt event, Emitter<AssistantState> emit) {
    final currentState = state;
    final messages = _extractMessages(currentState);
    
    if (currentState is Streaming) {
      emit(AssistantState.streaming(
        messages: messages,
        currentResponse: currentState.currentResponse + event.text,
      ));
    } else {
      emit(AssistantState.streaming(
        messages: messages,
        currentResponse: event.text,
      ));
    }
  }

  void _onToolCallReceived(ToolCallReceivedEvt event, Emitter<AssistantState> emit) {
    final currentState = state;
    final messages = _extractMessages(currentState);
    emit(AssistantState.toolCallRequested(
      messages: messages,
      toolCall: event.toolCall,
    ));
  }

  Future<void> _onToolExecuted(ToolExecutedEvt event, Emitter<AssistantState> emit) async {
    final currentState = state;
    if (currentState is ToolCallRequested) {
      try {
        await _repository.sendToolResult(currentState.toolCall.id, event.result.toString());
        emit(AssistantState.connected(messages: currentState.messages));
      } catch (e) {
        emit(AssistantState.error(
          message: 'Failed to send tool result: $e',
          messages: currentState.messages,
        ));
      }
    }
  }

  Future<void> _onLoadHistory(LoadHistoryEvt event, Emitter<AssistantState> emit) async {
    try {
      final history = await _repository.loadChatHistory();
      emit(AssistantState.connected(messages: history));
    } catch (e) {
      emit(AssistantState.error(
        message: 'Failed to load history: $e',
        messages: [],
      ));
    }
  }

  Future<void> _onClearHistory(ClearHistoryEvt event, Emitter<AssistantState> emit) async {
    try {
      await _repository.clearChatHistory();
      emit(const AssistantState.connected(messages: []));
    } catch (e) {
      emit(AssistantState.error(
        message: 'Failed to clear history: $e',
        messages: [],
      ));
    }
  }

  void _handleServiceEvent(AgUiEvent event) {
    // Map AG-UI service events to bloc events
    switch (event.type) {
      case AgUiEventType.textChunk:
        final text = (event.data['text'] ?? event.data['content']) as String?;
        if (text != null) add(AssistantEvent.textChunkReceived(text: text));
        break;
      case AgUiEventType.toolCall:
        try {
          final toolCall = ToolCall.fromJson(event.data);
          add(AssistantEvent.toolCallReceived(toolCall: toolCall));
        } catch (_) {
          // ignore malformed tool call
        }
        break;
      case AgUiEventType.runStarted:
      case AgUiEventType.runFinished:
      case AgUiEventType.error:
        // TODO: map other event types to states if needed
        break;
    }
  }

  List<ChatMessage> _extractMessages(AssistantState currentState) {
    if (currentState is Connected) return currentState.messages;
    if (currentState is MessageSending) return currentState.messages;
    if (currentState is Streaming) return currentState.messages;
    if (currentState is ToolCallRequested) return currentState.messages;
    if (currentState is Error) return currentState.messages;
    return [];
  }

  @override
  Future<void> close() {
    _eventSubscription?.cancel();
    return super.close();
  }
}