import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/features/assessment/assasment_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_destination.dart';
import 'complete_profile_screen.dart';
import '../dashboard/home_screen.dart';
import 'login_page.dart';
import 'provider/auth_provider.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();

    final authProvider = context.read<AuthProvider>();

   _authSubscription = authProvider.authStateChanges.listen(
  (data) async {
    final event = data.event;

    if (event == AuthChangeEvent.signedIn ||
        event == AuthChangeEvent.signedOut ||
        event == AuthChangeEvent.initialSession) {
      await _navigate();
    }
  },
);
  }

  void _goTo(Widget page) {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  Future<void> _navigate() async {
    if (!mounted) return;
    final authProvider = context.read<AuthProvider>();

    final destination = await authProvider.getDestination();

    if (!mounted) return;

   switch (destination) {
  case AuthDestination.login:
    _goTo(const LoginScreen());
    break;

  case AuthDestination.home:
    _goTo(const HomeScreen());
    break;

  case AuthDestination.assessment:
    _goTo(const AssasmentScreen());
    break;

  case AuthDestination.completeProfile:
    _goTo(const CompleteProfileScreen());
    break;
}
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
