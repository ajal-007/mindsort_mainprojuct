import 'package:mainsupabase_projuct/features/assessment/models/assasment_answer.dart';
import 'package:mainsupabase_projuct/features/assessment/models/assasment_result.dart';
import 'package:mainsupabase_projuct/features/assessment/models/mental_stage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AssasmentRepository {
final _supabase = Supabase.instance.client;

Future<int> getNextAssessmentNumber(String userId) async {
  final response = await _supabase
      .from('assessment_results')
      .select('assessment_number')
      .eq('user_id', userId)
      .order('assessment_number', ascending: false)
      .limit(1);

  if (response.isEmpty) {
    return 1;
  }

  final lastAssessmentNumber = response.first['assessment_number'] as int;

  return lastAssessmentNumber + 1;
}

Future<String> saveAssessmentResult({
  required String userId,
  required AssessmentResult result,
}) async {
  final assessmentNumber =
      await getNextAssessmentNumber(userId);

  final response = await _supabase
      .from('assessment_results')
      .insert({
        'user_id': userId,
        'assessment_number': assessmentNumber,
        'clarity_score': result.clarityScore,
        'stress_score': result.stressScore,
        'focus_score': result.focusScore,
        'emotion_score': result.emotionScore,
        'productivity_score': result.productivityScore,
        'overall_clarity': result.overallClarity,
        'mental_stage': result.stage.title,
        'assessment_version': 1,
      })
      .select('id')
      .single();

  return response['id'] as String;
}

Future<void> _saveAnswers({
  required String assessmentResultId,
  required String userId,
  required Map<String, AssessmentAnswer> answers,
}) async {
  final List<Map<String, dynamic>> rows = [];

  for (final answer in answers.values) {
    rows.add({
      'assessment_result_id': assessmentResultId,
      'user_id': userId,
      'question_id': answer.questionId,
      'selected_score': answer.selectedScore,
    });
  }

  await _supabase
      .from('assessment_answers')
      .insert(rows);
}

Future<void> updateProfile({
  required String userId,
  required AssessmentResult result,
}) async {
  await _supabase
      .from('profiles')
      .update({
        'assessment_completed': true,
        'assessment_completed_at': DateTime.now().toIso8601String(),
        'current_stage': result.stage.title,
        'current_clarity_score': result.overallClarity,
      })
      .eq('id', userId);
}

Future<void> saveAssessment({
  required AssessmentResult result,
  required Map<String, AssessmentAnswer> answers,
}) async {
  final user = _supabase.auth.currentUser;

  if (user == null) {
    throw Exception('User not logged in.');
  }

  final assessmentResultId = await saveAssessmentResult(
    userId: user.id,
    result: result,
  );

  await _saveAnswers(
    assessmentResultId: assessmentResultId,
    userId: user.id,
    answers: answers,
  );

  await updateProfile(
    userId: user.id,
    result: result,
  );
}
}