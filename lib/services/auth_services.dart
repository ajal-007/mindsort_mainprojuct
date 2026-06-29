import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> sendOtp(String email) async {
    await supabase.auth.signInWithOtp(email: email);
  }

  Future<AuthResponse> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await supabase.auth.verifyOTP(
      email: email,
      token: otp,
      type: OtpType.email,
    );

    return response;
  }

  Future<bool> profileExists() async {
    final user = supabase.auth.currentUser;

    final profile = await supabase
        .from('profiles')
        .select()
        .eq('id', user!.id)
        .maybeSingle();

    return profile != null;
  }

  Future<void> createProfile({required String username}) async {
    final user = supabase.auth.currentUser!;

    await supabase.from('profiles').insert({
      'id': user.id,
      'email': user.email,
      'username': username,
    });
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<bool> signInWithGoogle() async {
    return await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: kIsWeb ? null : 'io.supabase.flutter://login-callback',
    );
  }

  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  Stream<AuthState> get authStateChanges {
    return supabase.auth.onAuthStateChange;
  }
}
