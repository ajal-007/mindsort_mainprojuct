import 'package:flutter/material.dart';
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
        child: Text(
          message.content,
          style: TextStyle(
            color: isUser
                ? Colors.white
                : Colors.black87,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}