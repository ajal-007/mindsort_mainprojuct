import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/authentication/auth_destination.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool isLoading = false;
  String? error;

  Future<void> sendOtp(String email) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _authRepository.sendOtp(email);
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

      await _authRepository.verifyOtp(
        email: email,
        otp: otp,
      );

      final exists = await _authRepository.profileExists();

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

      return await _authRepository.profileExists();
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

      await _authRepository.createProfile(
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

      await _authRepository.signOut();
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

      await _authRepository.signInWithGoogle();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Stream<AuthState> get authStateChanges {
    return _authRepository.authStateChanges;
  }

  User? getCurrentUser() {
    return _authRepository.getCurrentUser();
  }

  Future<AuthDestination> getDestination() async {
    final user = getCurrentUser();

    if (user == null) {
      return AuthDestination.login;
    }

    final exists = await _authRepository.profileExists();

    if (exists) {
      return AuthDestination.home;
    }

    return AuthDestination.completeProfile;
  }

  Future<void> resendOtp(String email) async {
    try {
      await _authRepository.resendOtp(email);
    } on AuthException catch (e) {
      error = e.message;
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final user = getCurrentUser();
    if (user == null) return null;
    return await _authRepository.getProfile(user.id);
  }
}
