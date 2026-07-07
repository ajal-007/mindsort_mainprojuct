import 'package:flutter/material.dart';
import '../repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _profileRepository = ProfileRepository();

  Map<String, dynamic>? _profileData;
  Map<String, dynamic>? get profileData => _profileData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
}
