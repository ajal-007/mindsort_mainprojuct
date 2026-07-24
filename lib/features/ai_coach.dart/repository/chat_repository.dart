

import 'package:mainsupabase_projuct/features/ai_coach.dart/models/chat_message_model.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/models/chat_request_model.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/models/chat_response_model.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/models/chat_session_model.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/services/chat_ai_services.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/services/chat_services.dart';

class ChatRepository {
  final ChatService _chatService;
  final ChatAiService _chatAiService;

  ChatRepository({
    ChatService? chatService,
    ChatAiService? chatAiService,
  })  : _chatService = chatService ?? ChatService(),
        _chatAiService = chatAiService ?? ChatAiService();

  /// Create a new chat session
  Future<ChatSessionModel> createSession() {
    return _chatService.createSession();
  }

  /// Get all chat sessions
  Future<List<ChatSessionModel>> getSessions() {
    return _chatService.getSessions();
  }

  /// Get all messages for a session
  Future<List<ChatMessageModel>> getMessages(
    String sessionId,
  ) {
    return _chatService.getMessages(sessionId);
  }

  /// Send a message to the AI
  Future<ChatResponseModel> sendMessage(
    ChatRequestModel request,
  ) {
    return _chatAiService.sendMessage(request);
  }

  /// Delete a chat session
  Future<void> deleteSession(
    String sessionId,
  ) {
    return _chatService.deleteSession(sessionId);
  }
}