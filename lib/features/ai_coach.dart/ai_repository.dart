import 'ai_service.dart';

class AiRepository {
  final AiService _aiService = AiService();

  Future<List<Map<String, dynamic>>> fetchMessages() async {
    return await _aiService.fetchMessages();
  }

  Future<void> addMessage(Map<String, dynamic> message) async {
    await _aiService.addMessage(message);
  }

  Future<String> simulateCoachResponse(String userText) async {
    return await _aiService.simulateCoachResponse(userText);
  }
}
