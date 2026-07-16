import 'package:flutter/material.dart';

import '../../dashboard/models/dashboardata.dart';
import '../models/challenge_model.dart';
import '../repository/challenge_repository.dart';

class ChallengeProvider extends ChangeNotifier {
  final ChallengeRepository _repository = ChallengeRepository();

  List<Challenge> _todayChallenges = [];
  List<Challenge> get todayChallenges => _todayChallenges;

  int _currentDay = 1;
  int get currentDay => _currentDay;

  List<Challenge> _challengesForSelectedDay = [];
  List<Challenge> get challengesForSelectedDay => _challengesForSelectedDay;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadJourneyState() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentDay = await _repository.getCurrentDay();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTodayChallenges({
    required DashboardData dashboard,
    String? difficulty,
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

  Future<void> loadChallengesForDay({
    required int day,
    required DashboardData dashboard,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _challengesForSelectedDay = await _repository.getChallengesForDay(
        day: day,
        dashboard: dashboard,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleChallenge(Challenge challenge) async {
    final originalState = List<Challenge>.from(_challengesForSelectedDay);
    final newCompletedStatus = !challenge.completed;

    try {
      final index = _challengesForSelectedDay.indexWhere((c) => c.id == challenge.id);
      if (index != -1) {
        _challengesForSelectedDay[index] = Challenge(
          id: challenge.id,
          day: challenge.day,
          challengeNumber: challenge.challengeNumber,
          title: challenge.title,
          description: challenge.description,
          estimatedMinutes: challenge.estimatedMinutes,
          difficulty: challenge.difficulty,
          completed: newCompletedStatus,
        );
        notifyListeners();
      }

      await _repository.completeChallenge(challenge, newCompletedStatus);
    } catch (e) {
      _challengesForSelectedDay = originalState;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> advanceToNextDay({
    required DashboardData dashboard,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final current = await _repository.getCurrentDay();
      final nextDay = current + 1;
      await _repository.advanceDay(nextDay);
      _currentDay = nextDay;

      // Refresh today's challenges inside provider
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