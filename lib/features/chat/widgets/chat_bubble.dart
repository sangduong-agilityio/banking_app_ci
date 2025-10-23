import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/chat_message.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final ChatMessage? previousMessage;
  final bool showTimestamp;
  final VoidCallback? onRetry;

  const ChatBubble({
    Key? key,
    required this.message,
    this.previousMessage,
    this.showTimestamp = false,
    this.onRetry,
  }) : super(key: key);

  bool get _shouldShowDate {
    if (previousMessage == null) return true;
    final prevTs = previousMessage!.timestamp;
    final curTs = message.timestamp;
    if (prevTs == null || curTs == null) return true;
    final previousDate = DateTime(prevTs.year, prevTs.month, prevTs.day);
    final currentDate = DateTime(curTs.year, curTs.month, curTs.day);
    return previousDate != currentDate;
  }

  @override
  Widget build(BuildContext context) {
  final isUserMessage = message.type == ChatMessageType.user;
    final bubbleColor = isUserMessage 
      ? Theme.of(context).primaryColor 
      : Theme.of(context).scaffoldBackgroundColor;
    final textColor = isUserMessage 
      ? Colors.white 
      : Theme.of(context).textTheme.bodyLarge?.color;

    return Column(
      children: [
        if (_shouldShowDate)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              message.timestamp != null
                  ? DateFormat('EEEE, MMMM d').format(message.timestamp!)
                  : '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
        Align(
          alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(
              left: isUserMessage ? 64.0 : 8.0,
              right: isUserMessage ? 8.0 : 64.0,
              top: 4.0,
              bottom: 4.0,
            ),
            child: InkWell(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: message.content));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Message copied to clipboard'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.content,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (message.timestamp != null)
                          Text(
                            timeago.format(message.timestamp!),
                            style: TextStyle(
                              color: textColor?.withOpacity(0.7),
                              fontSize: 12.0,
                            ),
                          ),
                        if (message.status != null) ...[
                          const SizedBox(width: 4.0),
                          _buildStatusIndicator(context),
                        ],
                        if (message.error != null && onRetry != null) ...[
                          const SizedBox(width: 8.0),
                          InkWell(
                            onTap: onRetry,
                            child: Icon(
                              Icons.refresh,
                              size: 16.0,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(BuildContext context) {
    switch (message.status) {
      case MessageStatus.sending:
        return const SizedBox(
          width: 12.0,
          height: 12.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
        );
      case MessageStatus.sent:
        return const Icon(
          Icons.check,
          size: 16.0,
          color: Colors.green,
        );
      case MessageStatus.error:
        return Icon(
          Icons.error_outline,
          size: 16.0,
          color: Theme.of(context).colorScheme.error,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}