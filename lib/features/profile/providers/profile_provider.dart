import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_model.dart';
import '../models/profile_stats_model.dart';
import '../repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository = ProfileRepository();

  StreamSubscription<AuthState>? _authSubscription;

  ProfileModel? _profile;
  ProfileModel? get profile => _profile;

  ProfileStatsModel? _stats;
  ProfileStatsModel? get stats => _stats;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  ProfileProvider() {
    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen(
      (data) {
        if (data.event == AuthChangeEvent.signedOut) {
          _profile = null;
          _stats = null;
          _error = null;
          _isLoading = false;
          notifyListeners();
        }
      },
    );
  }

  Future<void> loadProfile(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _profile = await _repository.getProfile(userId);

      _stats = await _repository.getProfileStats(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh(String userId) async {
    await loadProfile(userId);
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}