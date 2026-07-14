import 'package:flutter/material.dart';

import '../../dashboard/models/dashboardata.dart';
import '../models/challenge_model.dart';
import '../repository/challenge_repository.dart';

class ChallengeProvider extends ChangeNotifier {
  final ChallengeRepository _repository = ChallengeRepository();

  List<Challenge> _todayChallenges = [];

  List<Challenge> get todayChallenges => _todayChallenges;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadTodayChallenges({
    required DashboardData dashboard,
    required String difficulty,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _todayChallenges = await _repository.getTodayChallenges(
        dashboard: dashboard,
    
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}