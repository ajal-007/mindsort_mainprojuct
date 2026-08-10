import 'dart:typed_data';

import '../models/profile_model.dart';
import '../models/profile_stats_model.dart';
import '../services/profile_service.dart';

class ProfileRepository {
  final ProfileService _profileService = ProfileService();

  Future<ProfileModel?> getProfile(
    String userId,
  ) async {
    return await _profileService.getProfile(userId);
  }

  Future<ProfileStatsModel> getProfileStats(
    String userId,
  ) async {
    return await _profileService.getProfileStats(userId);
  }

  Future<bool> isUsernameAvailable({
    required String username,
    required String userId,
  }) async {
    return await _profileService.isUsernameAvailable(
      username: username,
      userId: userId,
    );
  }

  Future<void> updateProfile({
    required String userId,
    required String username,
    String? avatarUrl,
  }) async {
    await _profileService.updateProfile(
      userId: userId,
      username: username,
      avatarUrl: avatarUrl,
    );
  }

  Future<String> uploadAvatar({
    required String userId,
    required Uint8List bytes,
    required String extension,
  }) async {
    return await _profileService.uploadAvatar(
      userId: userId,
      bytes: bytes,
      extension: extension,
    );
  }
}