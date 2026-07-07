import '../services/dashboard_service.dart';

class DashboardRepository {
  final DashboardService _dashboardService = DashboardService();

  Future<int> fetchClarityPercentage() async {
    return await _dashboardService.fetchClarityPercentage();
  }

  Future<Map<String, String>> fetchStreakMetrics() async {
    return await _dashboardService.fetchStreakMetrics();
  }

  Future<Map<String, String>> fetchStructuredMetrics() async {
    return await _dashboardService.fetchStructuredMetrics();
  }

  Future<Map<String, String>> fetchFocusMetrics() async {
    return await _dashboardService.fetchFocusMetrics();
  }

  Future<List<Map<String, dynamic>>> fetchAdviceCards() async {
    return await _dashboardService.fetchAdviceCards();
  }
}
