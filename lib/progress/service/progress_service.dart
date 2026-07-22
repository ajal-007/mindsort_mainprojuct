import 'dart:developer' as developer;

import 'package:mainsupabase_projuct/progress/models/progress_point_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProgressService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetches the assessment history for the current user.
  Future<List<ProgressPoint>> fetchProgressHistory() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in.');
    }

    try {
      final response = await _supabase
          .from('assessment_results')
          .select(
            'assessment_number, overall_clarity, created_at',
          )
          .eq('user_id', user.id)
          .order(
            'assessment_number',
            ascending: true,
          );

      final progress = (response as List)
          .map(
            (item) => ProgressPoint.fromMap(
              item as Map<String, dynamic>,
            ),
          )
          .toList();

      developer.log(
        'Fetched ${progress.length} progress points.',
        name: 'ProgressService',
      );

      return progress;
    } catch (e, stackTrace) {
      developer.log(
        'Failed to fetch progress history.',
        name: 'ProgressService',
        error: e,
        stackTrace: stackTrace,
      );

      throw Exception('Failed to fetch progress history.');
    }
  }
}