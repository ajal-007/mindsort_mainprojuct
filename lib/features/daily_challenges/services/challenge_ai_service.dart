import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/ai_challenge_response.dart';
import '../../dashboard/models/dashboardata.dart';

class ChallengeAIService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AIChallengeResponse> generateChallenges({
    required DashboardData dashboard,
    required int currentDay,
    required String difficulty,
  }) async {
    final response = await _supabase.functions.invoke(
      'challenge-ai',
      body: {
        'currentDay': currentDay,
        'difficulty': difficulty,
        'overallClarity': dashboard.overallClarity,
        'mentalStage': dashboard.mentalStage,
        'stressScore': dashboard.stressScore,
        'focusScore': dashboard.focusScore,
        'emotionScore': dashboard.emotionScore,
        'productivityScore': dashboard.productivityScore,
      },
    );

    if (response.data == null) {
      throw Exception('Failed to generate challenges.');
    }

    return AIChallengeResponse.fromJson(response.data);
  }
}