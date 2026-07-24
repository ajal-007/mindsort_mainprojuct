import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/models/chat_message_model.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/widgets/chatBubble.dart';


class ChatMessageList extends StatelessWidget {
  final List<ChatMessageModel> messages;

  const ChatMessageList({
    super.key,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ChatBubble(
          message: messages[index],
        );
      },
    );
  }
}