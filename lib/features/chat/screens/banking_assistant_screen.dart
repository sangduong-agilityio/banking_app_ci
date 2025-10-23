import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/assistant_bloc.dart';
import '../bloc/assistant_event.dart';
import '../bloc/assistant_state.dart';
import '../models/chat_message.dart';
import '../tools/tool_registry.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/typing_indicator.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<AssistantBloc>().add(const AssistantEvent.initialize());
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _handleToolCall(BuildContext context, ToolCallRequested state) async {
    final handler = ToolRegistry.getHandler(state.toolCall.toolName);
    if (handler == null) {
      context.read<AssistantBloc>().add(
        AssistantEvent.toolExecuted(
          toolName: state.toolCall.toolName,
          result: {'error': 'Tool not found'},
        ),
      );
      return;
    }

    try {
      final confirmed = await handler.showConfirmation(context, state.toolCall.arguments);
      if (!confirmed) {
        context.read<AssistantBloc>().add(
          AssistantEvent.toolExecuted(
            toolName: state.toolCall.toolName,
            result: {'error': 'User declined'},
          ),
        );
        return;
      }

      final result = await handler.execute(context, state.toolCall.arguments);
      context.read<AssistantBloc>().add(
        AssistantEvent.toolExecuted(
          toolName: state.toolCall.toolName,
          result: result,
        ),
      );
    } catch (e) {
      context.read<AssistantBloc>().add(
        AssistantEvent.toolExecuted(
          toolName: state.toolCall.toolName,
          result: {'error': e.toString()},
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banking Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              context.read<AssistantBloc>().add(const AssistantEvent.clearHistory());
            },
          ),
        ],
      ),
      body: BlocConsumer<AssistantBloc, AssistantState>(
        listener: (context, state) {
          if (state is ToolCallRequested) {
            _handleToolCall(context, state);
          }

          if (state is Connected || state is MessageSending || state is Streaming) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
          }
        },
        builder: (context, state) {
          List<ChatMessage> messages = [];
          if (state is Connected) messages = state.messages;
          else if (state is MessageSending) messages = state.messages;
          else if (state is Streaming) messages = state.messages;
          else if (state is ToolCallRequested) messages = state.messages;
          else if (state is Error) messages = state.messages;

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<AssistantBloc>().add(const AssistantEvent.loadHistory());
                  },
                  child: messages.isEmpty
                      ? Center(
                          child: Text(
                            'How can I help you today?',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context).hintColor,
                                ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          itemCount: messages.length + (state is Streaming ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == messages.length && state is Streaming) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TypingIndicator(),
                                    Expanded(
                                      child: ChatBubble(
                                        message: ChatMessage.assistant(
                                          id: 'assistant-${DateTime.now().microsecondsSinceEpoch}',
                                          content: state.currentResponse,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            final prev = index > 0 ? messages[index - 1] : null;
                            return ChatBubble(
                              message: messages[index],
                              previousMessage: prev,
                              onRetry: () {
                                final msg = messages[index];
                                if (msg.status == MessageStatus.error) {
                                  context.read<AssistantBloc>().add(
                                    AssistantEvent.sendMessage(message: msg.content),
                                  );
                                }
                              },
                            );
                          },
                        ),
                ),
              ),
              if (state is Error)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          state.message,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Type your message...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (text) {
                          if (text.isNotEmpty) {
                            context.read<AssistantBloc>().add(
                              AssistantEvent.sendMessage(message: text),
                            );
                            _textController.clear();
                            _scrollToBottom();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        final text = _textController.text;
                        if (text.isNotEmpty) {
                          context.read<AssistantBloc>().add(
                            AssistantEvent.sendMessage(message: text),
                          );
                          _textController.clear();
                          _scrollToBottom();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}