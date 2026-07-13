import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/features/dashboard/models/ai_insightmodel.dart';
import 'package:mainsupabase_projuct/features/dashboard/models/dashboardata.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import '../repository/ai_repository.dart';

class AiDashboardProvider extends ChangeNotifier {
  final AIRepository _repository = AIRepository();
  StreamSubscription<AuthState>? _authSubscription;

  AIInsight? _insight;
  AIInsight? get insight => _insight;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  AiDashboardProvider() {
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedOut) {
        clearInsight();
      }
    });
  }

  Future<void> generateInsight(
    DashboardData dashboard,
  ) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _insight = await _repository.generateInsight(dashboard);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearInsight() {
    _insight = null;
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}