import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/models/chat_message_model.dart';


class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  String _cleanKeycapEmojis(String text) {
    return text.replaceAllMapped(
      RegExp(r'([0-9])\uFE0F?\u20E3\s*'),
      (match) => '${match.group(1)}. ',
    );
  }

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
              : const Color(0xFF1E2235),
          border: isUser
              ? null
              : Border.all(
                  color: const Color(0xFF2E3452),
                  width: 1,
                ),
          borderRadius: isUser
              ? BorderRadius.circular(18)
              : const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(4),
                ),
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
        data: _cleanKeycapEmojis(message.content),
        selectable: true,
        styleSheet: MarkdownStyleSheet(
          p: const TextStyle(
            color: Color(0xFFEAECEF),
            fontSize: 15,
            height: 1.45,
          ),
          h1: const TextStyle(
            color: Color(0xFFEAECEF),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          h2: const TextStyle(
            color: Color(0xFFEAECEF),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          h3: const TextStyle(
            color: Color(0xFFEAECEF),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          strong: const TextStyle(
            color: Color(0xFFEAECEF),
            fontWeight: FontWeight.bold,
          ),
          listBullet: const TextStyle(
            color: Color(0xFFEAECEF),
          ),
          code: TextStyle(
            backgroundColor: const Color(0xFF2E3452),
            color: const Color(0xFFEAECEF),
            fontFamily: 'monospace',
          ),
        ),
      ),
      ),
    );
  }
}

