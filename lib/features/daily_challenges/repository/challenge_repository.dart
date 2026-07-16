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
    final currentDay = await getCurrentDay();
    return await getChallengesForDay(day: currentDay, dashboard: dashboard);
  }

  Future<List<Challenge>> getChallengesForDay({
    required int day,
    required DashboardData dashboard,
  }) async {
    final existing = await _service.fetchChallengesForDay(day);

    if (existing.isNotEmpty) {
      return existing;
    }

    // Only generate using AI if it's the current active day
    final currentDay = await _service.getCurrentDay();
    if (day == currentDay) {
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
      return await _service.fetchChallengesForDay(currentDay);
    }

    return [];
  }

  Future<int> getCurrentDay() async {
    return await _service.getCurrentDay();
  }

  Future<void> completeChallenge(Challenge challenge, bool completed) async {
    await _service.updateChallengeCompletion(challenge.id, completed);
  }

  Future<void> advanceDay(int nextDay) async {
    await _service.updateCurrentDay(nextDay);
  }
}
