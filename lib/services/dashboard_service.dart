import '../../core/constants/app_text.dart';

class DashboardService {
  Future<int> fetchClarityPercentage() async {
    return 78;
  }

  Future<Map<String, String>> fetchStreakMetrics() async {
    return {
      'title': AppText.streakTitle,
      'value': AppText.streakValue,
      'sub': AppText.streakSub,
    };
  }

  Future<Map<String, String>> fetchStructuredMetrics() async {
    return {
      'title': AppText.structuredTitle,
      'value': AppText.structuredValue,
      'sub': AppText.structuredSub,
    };
  }

  Future<Map<String, String>> fetchFocusMetrics() async {
    return {
      'title': AppText.weeklyFocusTitle,
      'growth': AppText.weeklyFocusGrowth,
      'sub': AppText.avgDeepWorkSub,
    };
  }

  Future<List<Map<String, dynamic>>> fetchAdviceCards() async {
    return [
      {
        'title': AppText.advicePeakTitle,
        'desc': AppText.advicePeakDesc,
        'type': 'peak',
      },
      {
        'title': AppText.adviceDeficitTitle,
        'desc': AppText.adviceDeficitDesc,
        'type': 'deficit',
      }
    ];
  }
}
