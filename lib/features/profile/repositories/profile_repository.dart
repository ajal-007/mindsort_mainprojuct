import '../models/profile_model.dart';
import '../models/profile_stats_model.dart';
import '../services/profile_service.dart';

class ProfileRepository {
  final ProfileService _profileService =
      ProfileService();

  Future<ProfileModel?> getProfile(
    String userId,
  ) async {
    return await _profileService.getProfile(
      userId,
    );
  }

  Future<ProfileStatsModel> getProfileStats(
    String userId,
  ) async {
    return await _profileService.getProfileStats(
      userId,
    );
  }
}