import 'package:flutter/foundation.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/models/chat_message_model.dart';

@immutable
class ChatResponseModel {
  final bool success;
  final String? title;
  final ChatMessageModel? reply;
  final String? error;

  const ChatResponseModel({
    required this.success,
    this.title,
    this.reply,
    this.error,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      success: json['success'] as bool,
      title: json['title'] as String?,
      reply: json['reply'] != null
          ? ChatMessageModel(
              id: '',
              sessionId: '',
              role: json['reply']['role'] as String,
              content: json['reply']['content'] as String,
              createdAt: DateTime.now(),
            )
          : null,
      error: json['error'] as String?,
    );
  }
}