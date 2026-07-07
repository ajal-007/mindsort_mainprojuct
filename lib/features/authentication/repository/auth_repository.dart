import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Future<void> sendOtp(String email) async {
    await _authService.sendOtp(email);
  }

  Future<AuthResponse> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return await _authService.verifyOtp(email: email, otp: otp);
  }

  Future<bool> profileExists() async {
    return await _authService.profileExists();
  }

  Future<void> createProfile({required String username}) async {
    await _authService.createProfile(username: username);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<bool> signInWithGoogle() async {
    return await _authService.signInWithGoogle();
  }

  User? getCurrentUser() {
    return _authService.getCurrentUser();
  }

  Stream<AuthState> get authStateChanges {
    return _authService.authStateChanges;
  }

  Future<void> resendOtp(String email) async {
    await _authService.resendOtp(email);
  }

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    return await _authService.getProfile(userId);
  }
}
