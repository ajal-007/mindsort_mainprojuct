import 'package:mainsupabase_projuct/features/profile/models/profile_model.dart';
import 'package:mainsupabase_projuct/features/profile/models/profile_stats_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<ProfileModel?> getProfile(String userId) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return ProfileModel.fromJson(response);
  }

  Future<ProfileStatsModel> getProfileStats(
  String userId,
) async {
  // Assessment count
  final assessmentResponse = await _supabase
      .from('assessment_results')
      .select('id')
      .eq('user_id', userId);

  final assessmentCount = assessmentResponse.length;

  // Completed challenges count
  final completedChallengesResponse = await _supabase
      .from('user_daily_challenges')
      .select('id')
      .eq('user_id', userId)
      .eq('completed', true);

  final completedChallengesCount =
      completedChallengesResponse.length;

  // Current streak
  int currentStreak = 0;
  try {
    final progressResponse = await _supabase
        .from('user_challenge_progress')
        .select('current_streak')
        .eq('user_id', userId)
        .single();
    currentStreak = progressResponse['current_streak'] ?? 0;
  } catch (e) {
    currentStreak = 0;
  }

  return ProfileStatsModel(
    currentStreak: currentStreak,
    assessments: assessmentCount,
    completedChallenges: completedChallengesCount,
  );
}
}