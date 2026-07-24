import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/provider/chat_provider.dart';
import 'package:mainsupabase_projuct/features/assessment/provider/assasment_provider.dart';
import 'package:mainsupabase_projuct/features/dashboard/provider/ai_dashboard_provider.dart';
import 'package:mainsupabase_projuct/progress/provider/progress_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/app_api.dart';
import 'core/theme/app_theme.dart';
import 'features/authentication/auth_gate.dart';
import 'features/authentication/provider/auth_provider.dart';

import 'features/dashboard/provider/dashboard_provider.dart';
import 'features/profile/providers/profile_provider.dart';
import 'features/daily_challenges/providers/challenge_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppApi.supabaseUrl,
    anonKey: AppApi.supabaseAnonKey,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        ChangeNotifierProvider(create: (_) => AssessmentProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ChallengeProvider()),
        ChangeNotifierProvider(create: (_) => AiDashboardProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: AppTheme.darkTheme,
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}
