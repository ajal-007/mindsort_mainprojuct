import 'package:mainsupabase_projuct/features/daily_challenges/models/challenge_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class ChallengeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Returns today's challenges if they already exist.
  Future<List<Challenge>> fetchTodayChallenges() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in.');
    }

     final currentDay = await getCurrentDay();

    // Load today's challenges
    final response = await _supabase
        .from('user_daily_challenges')
        .select()
        .eq('user_id', user.id)
        .eq('challenge_day', currentDay)
        .order('challenge_number');

    return response
        .map<Challenge>((json) => Challenge.fromJson(json))
        .toList();
  }
/// Save newly AI-generated challenges.
Future<void> saveTodayChallenges({
  required int currentDay,
  required List<Challenge> challenges,
}) async {
  final user = _supabase.auth.currentUser;

  if (user == null) {
    throw Exception('User not logged in.');
  }

  final data = challenges.map((challenge) {
    return {
      'user_id': user.id,
      'challenge_day': currentDay,
      'challenge_number': challenge.challengeNumber,
      'title': challenge.title,
      'description': challenge.description,
      'estimated_minutes': challenge.estimatedMinutes,
      'difficulty': challenge.difficulty.name,
      'completed': false,
    };
  }).toList();

  await _supabase
      .from('user_daily_challenges')
      .insert(data);
}

Future<int> getCurrentDay() async {
  final user = _supabase.auth.currentUser;

  if (user == null) {
    throw Exception('User not logged in.');
  }

  final response = await _supabase
      .from('user_challenge_progress')
      .select('current_day')
      .eq('user_id', user.id)
      .single();

  return response['current_day'];
}

}