import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/auth_gate/auth_destination.dart';
import 'package:mainsupabase_projuct/pages/complete_profile_screen.dart';
import 'package:mainsupabase_projuct/pages/home_screen.dart';
import 'package:mainsupabase_projuct/pages/login_page.dart';
import 'package:mainsupabase_projuct/providers/authprovider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {

  late final StreamSubscription<AuthState>? _authSubscription;

@override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final authProvider = context.read<AuthProvider>();

    _authSubscription = authProvider.authStateChanges.listen (
      (data) async {

     
    await _navigate();
  },
    );
  });
}
void _goTo(Widget page) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => page),
    (route) => false,
  );
}
Future<void> _navigate() async {

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