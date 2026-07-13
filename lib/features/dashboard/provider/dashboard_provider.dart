import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/features/dashboard/models/dashboardata.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../repository/dashboard_repository.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardRepository _dashboardRepository = DashboardRepository();
  StreamSubscription<AuthState>? _authSubscription;

  DashboardData? _dashboard;
  DashboardData? get dashboard => _dashboard;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  DashboardProvider() {
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      final event = data.event;

      if (session != null &&
          (event == AuthChangeEvent.signedIn ||
           event == AuthChangeEvent.initialSession ||
           event == AuthChangeEvent.tokenRefreshed)) {
        loadDashboard();
      } else if (event == AuthChangeEvent.signedOut) {
        _dashboard = null;
        _error = null;
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<void> loadDashboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _dashboard = await _dashboardRepository.getDashboard();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadDashboard();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}