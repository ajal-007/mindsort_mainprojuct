import 'package:mainsupabase_projuct/features/ai_coach.dart/models/chat_request_model.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/models/chat_response_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatAiService {

  final SupabaseClient _supabase = Supabase.instance.client;

    /// Send a message to the Edge Function
  Future<ChatResponseModel> sendMessage(
    ChatRequestModel request,
  ) async {
    final response = await _supabase.functions.invoke(
      'chat-ai',
      body: request.toJson(),
    );

    if (response.data == null) {
      throw Exception('No response from AI.');
    }

    return ChatResponseModel.fromJson(response.data);
  }
}
