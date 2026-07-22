import 'package:mainsupabase_projuct/features/daily_challenges/models/challenge_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;

class ChallengeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Challenge>> fetchTodayChallenges() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in.');
    }

    final currentDay = await getCurrentDay();

    final response = await _supabase
        .from('user_daily_challenges')
        .select()
        .eq('user_id', user.id)
        .eq('challenge_day', currentDay)
        .order('challenge_number');

    return response.map<Challenge>((json) => Challenge.fromJson(json)).toList();
  }

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

    await _supabase.from('user_daily_challenges').insert(data);
  }

  Future<int> getCurrentDay() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in.');
    }

    try {
      final response = await _supabase
          .from('user_challenge_progress')
          .select('current_day')
          .eq('user_id', user.id);

      if (response.isEmpty) {
        try {
          await _supabase.from('user_challenge_progress').insert({
            'user_id': user.id,
            'current_day': 1,
          });
        } catch (insertError) {
          developer.log(
            "Warning: Failed to insert user_challenge_progress due to RLS: $insertError",
          );
        }
        return 1;
      }

      return response.first['current_day'] as int;
    } catch (fetchError) {
      developer.log(
        "Warning: Failed to fetch user_challenge_progress: $fetchError",
      );
      return 1;
    }
  }

  Future<List<Challenge>> fetchChallengesForDay(int day) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in.');
    }

    final response = await _supabase
        .from('user_daily_challenges')
        .select()
        .eq('user_id', user.id)
        .eq('challenge_day', day)
        .order('challenge_number');

    return response.map<Challenge>((json) => Challenge.fromJson(json)).toList();
  }

  Future<void> updateChallengeCompletion(
    String challengeId,
    bool completed,
  ) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in.');
    }

    await _supabase
        .from('user_daily_challenges')
        .update({'completed': completed})
        .eq('id', challengeId)
        .eq('user_id', user.id);
  }

  Future<void> updateCurrentDay(int nextDay) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in.');
    }

    try {
      await _supabase
          .from('user_challenge_progress')
          .update({'current_day': nextDay})
          .eq('user_id', user.id);
    } catch (updateError) {
      developer.log(
        "Warning: Failed to update user_challenge_progress: $updateError",
      );
    }
  }
}
