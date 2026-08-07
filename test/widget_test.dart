import 'package:flutter_test/flutter_test.dart';
import 'package:mainsupabase_projuct/features/daily_challenges/models/journey_progress_model.dart';

void main() {
  test('JourneyProgressModel JSON parsing test', () {
    final json = {
      'currentDay': 5,
      'completedDays': 3,
      'currentStreak': 2,
    };
    final model = JourneyProgressModel.fromJson(json);
    expect(model.currentDay, 5);
    expect(model.completedDays, 3);
    expect(model.currentStreak, 2);
  });
}
