import 'package:flutter/material.dart';
import '../repositories/dashboard_repository.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardRepository _dashboardRepository = DashboardRepository();

  int _clarityPercentage = 0;
  int get clarityPercentage => _clarityPercentage;

  Map<String, String> _streakMetrics = {};
  Map<String, String> get streakMetrics => _streakMetrics;

  Map<String, String> _structuredMetrics = {};
  Map<String, String> get structuredMetrics => _structuredMetrics;

  Map<String, String> _focusMetrics = {};
  Map<String, String> get focusMetrics => _focusMetrics;

  List<Map<String, dynamic>> _adviceCards = [];
  List<Map<String, dynamic>> get adviceCards => _adviceCards;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DashboardProvider() {
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _clarityPercentage = await _dashboardRepository.fetchClarityPercentage();
      _streakMetrics = await _dashboardRepository.fetchStreakMetrics();
      _structuredMetrics = await _dashboardRepository.fetchStructuredMetrics();
      _focusMetrics = await _dashboardRepository.fetchFocusMetrics();
      _adviceCards = await _dashboardRepository.fetchAdviceCards();
    } catch (_) {
      // Handle loading error states if necessary
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
