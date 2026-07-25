import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/models/chat_message_model.dart';


class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';

    return Align(
      alignment:
          isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 300,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18),
        ),
        child: isUser
    ? Text(
        message.content,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      )
    : MarkdownBody(
        data: message.content,
        selectable: true,
        styleSheet: MarkdownStyleSheet(
          p: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
          ),
          h1: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          h2: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          h3: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          strong: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          listBullet: const TextStyle(
            color: Colors.black87,
          ),
          code: TextStyle(
            backgroundColor: Colors.grey.shade300,
            fontFamily: 'monospace',
          ),
        ),
      ),
      ),
    );
  }
}

