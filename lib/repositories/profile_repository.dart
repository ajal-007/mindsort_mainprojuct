import '../services/profile_service.dart';

class ProfileRepository {
  final ProfileService _profileService = ProfileService();

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    return await _profileService.getProfile(userId);
  }
}
