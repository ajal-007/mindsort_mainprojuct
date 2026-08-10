import 'dart:typed_data';

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

  Future<bool> isUsernameAvailable({
    required String username,
    required String userId,
  }) async {
    final response = await _supabase
        .from('profiles')
        .select('id')
        .eq('username', username)
        .neq('id', userId)
        .limit(1);

    return response.isEmpty;
  }

  Future<void> updateProfile({
    required String userId,
    required String username,
    String? avatarUrl,
  }) async {
    await _supabase
        .from('profiles')
        .update({
          'username': username,
          'avatar_url': avatarUrl,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId);
  }

  Future<String> uploadAvatar({
    required String userId,
    required Uint8List bytes,
    required String extension,
  }) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}.$extension';

    final path = '$userId/$fileName';

    await _supabase.storage
        .from('avatars')
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            upsert: false,
            contentType: 'image/$extension',
          ),
        );

    return _supabase.storage
        .from('avatars')
        .getPublicUrl(path);
  }

  Future<ProfileStatsModel> getProfileStats(
    String userId,
  ) async {
    final assessmentResponse = await _supabase
        .from('assessment_results')
        .select('id')
        .eq('user_id', userId);

    final assessmentCount = assessmentResponse.length;

    final completedChallengesResponse = await _supabase
        .from('user_daily_challenges')
        .select('id')
        .eq('user_id', userId)
        .eq('completed', true);

    final completedChallengesCount =
        completedChallengesResponse.length;

    int currentStreak = 0;

    try {
      final progressResponse = await _supabase
          .from('user_challenge_progress')
          .select('current_streak')
          .eq('user_id', userId)
          .single();

      currentStreak =
          (progressResponse['current_streak'] as int?) ?? 0;
    } catch (_) {
      currentStreak = 0;
    }

    return ProfileStatsModel(
      currentStreak: currentStreak,
      assessments: assessmentCount,
      completedChallenges: completedChallengesCount,
    );
  }
}