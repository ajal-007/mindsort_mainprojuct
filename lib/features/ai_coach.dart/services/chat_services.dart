
import 'package:mainsupabase_projuct/features/ai_coach.dart/models/chat_message_model.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/models/chat_session_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Create a new chat session
  Future<ChatSessionModel> createSession() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in.');
    }

    final response = await _supabase
        .from('chat_sessions')
        .insert({
          'user_id': user.id,
          'title': 'New Chat',
        })
        .select()
        .single();

    return ChatSessionModel.fromJson(response);
  }

  /// Fetch all chat sessions
  Future<List<ChatSessionModel>> getSessions() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in.');
    }

    final response = await _supabase
        .from('chat_sessions')
        .select()
        .eq('user_id', user.id)
        .order('updated_at', ascending: false);

    return response
        .map<ChatSessionModel>(
          (json) => ChatSessionModel.fromJson(json),
        )
        .toList();
  }

  /// Fetch messages for a session
  Future<List<ChatMessageModel>> getMessages(
    String sessionId,
  ) async {
    final response = await _supabase
        .from('chat_messages')
        .select()
        .eq('session_id', sessionId)
        .order('created_at', ascending: true);

    return response
        .map<ChatMessageModel>(
          (json) => ChatMessageModel.fromJson(json),
        )
        .toList();
  }



  /// Delete a chat session
  Future<void> deleteSession(
    String sessionId,
  ) async {
    await _supabase
        .from('chat_sessions')
        .delete()
        .eq('id', sessionId);
  }
}