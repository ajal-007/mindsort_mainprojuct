import 'package:mainsupabase_projuct/features/daily_challenges/models/challenge_model.dart';
import 'package:mainsupabase_projuct/features/daily_challenges/models/journey_progress_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;

class ChallengeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Track if we already incremented current_day during this app launch
  static bool _hasIncrementedThisLaunch = false;

  Future<void> checkAndUnlockNextDay() async {
    if (_hasIncrementedThisLaunch) {
      developer.log("checkAndUnlockNextDay: Already incremented in this app launch. Skipping.");
      return;
    }

    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in.');
    }

    try {
      final response = await _supabase
          .from('user_challenge_progress')
          .select('current_day, last_completed_date')
          .eq('user_id', user.id);

      if (response.isEmpty) {
        // Initialize progress for new user
        await _supabase.from('user_challenge_progress').insert({
          'user_id': user.id,
          'current_day': 1,
          'current_streak': 0,
          'last_completed_date': null,
        });
        return;
      }

      final data = response.first;
      final int currentDay = data['current_day'] ?? 1;
      final String? lastCompletedStr = data['last_completed_date'];

      if (lastCompletedStr != null) {
        final lastCompleted = DateTime.parse(lastCompletedStr);
        final lastCompletedDate = DateTime(
          lastCompleted.year,
          lastCompleted.month,
          lastCompleted.day,
        );

        final today = DateTime.now();
        final todayDate = DateTime(
          today.year,
          today.month,
          today.day,
        );

        if (todayDate.isAfter(lastCompletedDate)) {
          // Verify user has completed the current day before incrementing (Never skip days)
          final completedChallenges = await _supabase
              .from('user_daily_challenges')
              .select('challenge_day')
              .eq('user_id', user.id)
              .eq('completed', true);

          int maxCompletedDay = 0;
          if (completedChallenges.isNotEmpty) {
            maxCompletedDay = completedChallenges
                .map((e) => e['challenge_day'] as int)
                .reduce((a, b) => a > b ? a : b);
          }

          if (currentDay <= maxCompletedDay) {
            final nextDay = currentDay + 1;
            await _supabase
                .from('user_challenge_progress')
                .update({'current_day': nextDay})
                .eq('user_id', user.id);

            _hasIncrementedThisLaunch = true;
            developer.log("checkAndUnlockNextDay: Incremented current_day from $currentDay to $nextDay.");
          } else {
            developer.log("checkAndUnlockNextDay: currentDay ($currentDay) > maxCompletedDay ($maxCompletedDay). Skipping increment.");
          }
        }
      }
    } catch (e) {
      developer.log("checkAndUnlockNextDay error: $e");
    }
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
        return 1;
      }

      return response.first['current_day'] as int? ?? 1;
    } catch (e) {
      developer.log("getCurrentDay error: $e");
      return 1;
    }
  }

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

  Future<void> updateChallengeCompletion(
    String challengeId,
    bool completed,
  ) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in.');
    }

    // Update challenge in user_daily_challenges
    await _supabase
        .from('user_daily_challenges')
        .update({'completed': completed})
        .eq('id', challengeId)
        .eq('user_id', user.id);

    if (!completed) return;

    // Get the challenge_day of this challenge
    final challenge = await _supabase
        .from('user_daily_challenges')
        .select('challenge_day')
        .eq('id', challengeId)
        .single();

    final int challengeDay = challenge['challenge_day'] as int;

    // Fetch all challenges for this day to verify if all are completed
    final dayChallenges = await _supabase
        .from('user_daily_challenges')
        .select('completed')
        .eq('user_id', user.id)
        .eq('challenge_day', challengeDay);

    final allCompleted = dayChallenges.isNotEmpty &&
        dayChallenges.every((e) => e['completed'] == true);

    if (!allCompleted) {
      return;
    }

    // Load progress from user_challenge_progress
    final progressResponse = await _supabase
        .from('user_challenge_progress')
        .select('current_streak, last_completed_date')
        .eq('user_id', user.id);

    if (progressResponse.isEmpty) {
      final todayStr = DateTime.now().toIso8601String().split('T').first;
      await _supabase.from('user_challenge_progress').insert({
        'user_id': user.id,
        'current_day': challengeDay,
        'current_streak': 1,
        'last_completed_date': todayStr,
      });
      return;
    }

    final progress = progressResponse.first;
    final String? lastCompletedStr = progress['last_completed_date'];
    int streak = progress['current_streak'] ?? 0;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (lastCompletedStr != null) {
      final lastCompleted = DateTime.parse(lastCompletedStr);
      final lastCompletedDate = DateTime(
        lastCompleted.year,
        lastCompleted.month,
        lastCompleted.day,
      );

      if (todayDate.isAtSameMomentAs(lastCompletedDate)) {
        // Already completed today. Don't increment streak again or update date.
        return;
      }

      final difference = todayDate.difference(lastCompletedDate).inDays;
      if (difference == 1) {
        streak++;
      } else {
        streak = 1;
      }
    } else {
      streak = 1;
    }

    final todayStr = todayDate.toIso8601String().split('T').first;
    await _supabase
        .from('user_challenge_progress')
        .update({
          'current_streak': streak,
          'last_completed_date': todayStr,
        })
        .eq('user_id', user.id);
  }

  Future<JourneyProgressModel> getJourneyProgress() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in.');
    }

    // Fetch current day and current streak from user_challenge_progress
    final progressResponse = await _supabase
        .from('user_challenge_progress')
        .select('current_day, current_streak')
        .eq('user_id', user.id);

    final int currentDay = progressResponse.isNotEmpty
        ? (progressResponse.first['current_day'] ?? 1)
        : 1;
    final int currentStreak = progressResponse.isNotEmpty
        ? (progressResponse.first['current_streak'] ?? 0)
        : 0;

    // Completed days: count DISTINCT challenge_day from user_daily_challenges where completed = true
    final completedChallenges = await _supabase
        .from('user_daily_challenges')
        .select('challenge_day')
        .eq('user_id', user.id)
        .eq('completed', true);

    final completedDays = completedChallenges
        .map((e) => e['challenge_day'] as int)
        .toSet()
        .length;

    return JourneyProgressModel(
      currentDay: currentDay,
      completedDays: completedDays,
      currentStreak: currentStreak,
    );
  }
}
