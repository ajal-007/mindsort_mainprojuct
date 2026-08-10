import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_model.dart';
import '../models/profile_stats_model.dart';
import '../repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository = ProfileRepository();

  StreamSubscription? _authSubscription;

  ProfileModel? _profile;
  ProfileModel? get profile => _profile;

  ProfileStatsModel? _stats;
  ProfileStatsModel? get stats => _stats;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

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
          _isUpdating = false;

          notifyListeners();
        }
      },
    );
  }

  Future<void> loadProfile(String userId) async {
    if (userId.isEmpty) return;

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

  Future<bool> updateProfile({
    required String userId,
    required String username,
    String? avatarUrl,
  }) async {
    if (_isUpdating) return false;

    try {
      _isUpdating = true;
      _error = null;
      notifyListeners();

      final normalizedUsername =
          username.trim().toLowerCase();

      if (normalizedUsername.length < 3 ||
          normalizedUsername.length > 20) {
        _error =
            'Username must be between 3 and 20 characters.';
        return false;
      }

      final validUsername = RegExp(
        r'^[a-z0-9_]+$',
      ).hasMatch(normalizedUsername);

      if (!validUsername) {
        _error =
            'Username can only contain letters, numbers and _.';
        return false;
      }

      final available =
          await _repository.isUsernameAvailable(
        username: normalizedUsername,
        userId: userId,
      );

      if (!available) {
        _error = 'This username is already taken.';
        return false;
      }

      await _repository.updateProfile(
        userId: userId,
        username: normalizedUsername,
        avatarUrl: avatarUrl ?? _profile?.avatarUrl,
      );

      await loadProfile(userId);

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<String?> uploadAvatar({
    required String userId,
    required Uint8List bytes,
    required String extension,
  }) async {
    try {
      _isUpdating = true;
      _error = null;
      notifyListeners();

      final url = await _repository.uploadAvatar(
        userId: userId,
        bytes: bytes,
        extension: extension,
      );

      return url;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<void> refresh(String userId) async {
    await loadProfile(userId);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}