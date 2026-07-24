import 'package:flutter/foundation.dart';

@immutable
class ChatRequestModel {
  final String sessionId;
  final String message;

  const ChatRequestModel({
    required this.sessionId,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'message': message,
    };
  }
}