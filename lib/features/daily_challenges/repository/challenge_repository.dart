import 'package:mainsupabase_projuct/features/daily_challenges/models/challenge_difficulty.dart';
import 'package:mainsupabase_projuct/features/daily_challenges/models/challenge_model.dart';
import 'package:mainsupabase_projuct/features/daily_challenges/services/challenge_ai_service.dart';
import 'package:mainsupabase_projuct/features/daily_challenges/services/challenge_difficulty.dart';
import 'package:mainsupabase_projuct/features/dashboard/models/dashboardata.dart';
import '../services/challenge_service.dart';

class ChallengeRepository {
  final ChallengeService _service = ChallengeService();

  final ChallengeAIService _aiService = ChallengeAIService();

  Future<List<Challenge>> getTodayChallenges({
    required DashboardData dashboard,
  }) async {
    final existing = await _service.fetchTodayChallenges();

    if (existing.isNotEmpty) {
      return existing;
    }

    // No challenges -> Generate using AI
    final currentDay = await _service.getCurrentDay();

    final difficulty = ChallengeDifficultyService.getDifficulty(currentDay);
    final aiResponse = await _aiService.generateChallenges(
      dashboard: dashboard,
      currentDay: currentDay,
      difficulty: difficulty.title,
    );

    // Save to database
    await _service.saveTodayChallenges(
      currentDay: currentDay,
      challenges: aiResponse.challenges,
    );

    // Return newly saved challenges
    return await _service.fetchTodayChallenges();
  }
}
