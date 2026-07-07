import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/features/authentication/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth_destination.dart';
import 'package:mainsupabase_projuct/main.dart';
import 'package:mainsupabase_projuct/features/authentication/login_page.dart';


class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? error;

  AuthProvider() {
    _authService.authStateChanges.listen((data) {
      if (data.event == AuthChangeEvent.signedOut) {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    });
  }

  Future<void> sendOtp(String email) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _authService.sendOtp(email);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _authService.verifyOtp(
        email: email,
        otp: otp,
      );

      final exists = await _authService.profileExists();

      return exists;
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> profileExists() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      return await _authService.profileExists();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createProfile({
    required String username,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _authService.createProfile(
        username: username,
      );
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _authService.signOut();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _authService.signInWithGoogle();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Stream<AuthState> get authStateChanges {
    return _authService.authStateChanges;
  }

  User? getCurrentUser() {
    return _authService.getCurrentUser();
  }

  Future<AuthDestination> getDestination() async {
  final user = getCurrentUser();

  if (user == null) {
    return AuthDestination.login;
  }



  final profile = await _authService.getProfile(user.id);

  if (profile == null) {
    return AuthDestination.completeProfile;
  }

  if (profile['assessment_completed'] == true) {
    return AuthDestination.home;
  }

  return AuthDestination.assessment;
}

  Future<void> resendOtp(String email) async {
    try {
      await _authService.resendOtp(email);
    } on AuthException catch (e) {
      error = e.message;
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final user = getCurrentUser();
    if (user == null) return null;
    return await _authService.getProfile(user.id);
  }
}
