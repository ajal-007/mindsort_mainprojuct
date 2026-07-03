import '../services/assessment_service.dart';

class AssessmentRepository {
  final AssessmentService _assessmentService = AssessmentService();

  Future<List<Map<String, dynamic>>> fetchMessages() async {
    return await _assessmentService.fetchMessages();
  }

  Future<void> addMessage(Map<String, dynamic> message) async {
    await _assessmentService.addMessage(message);
  }

  Future<String> simulateCoachResponse(String userText) async {
    return await _assessmentService.simulateCoachResponse(userText);
  }
}
