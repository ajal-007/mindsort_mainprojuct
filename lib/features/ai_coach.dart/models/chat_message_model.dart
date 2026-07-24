import 'package:flutter/foundation.dart';

@immutable
class ChatMessageModel {
  final String id;
  final String sessionId;
  final String role;
  final String content;
  final DateTime createdAt;

  const ChatMessageModel({
    required this.id,
    required this.sessionId,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'role': role,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ChatMessageModel copyWith({
    String? id,
    String? sessionId,
    String? role,
    String? content,
    DateTime? createdAt,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}