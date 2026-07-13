import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _profileRepository = ProfileRepository();
  StreamSubscription<AuthState>? _authSubscription;

  Map<String, dynamic>? _profileData;
  Map<String, dynamic>? get profileData => _profileData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ProfileProvider() {
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedOut) {
        _profileData = null;
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<Map<String, dynamic>?> loadUserProfile(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _profileData = await _profileRepository.getProfile(userId);
      return _profileData;
    } catch (_) {
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
