import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/pages/complete_profile_screen.dart';
import 'package:mainsupabase_projuct/pages/login_page.dart';
import 'package:mainsupabase_projuct/pages/otp_screen.dart';
import 'package:mainsupabase_projuct/pages/splash_screen.dart';
import 'package:mainsupabase_projuct/providers/authprovider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://eknqgpbnhrjskvnoqfns.supabase.co',
    publishableKey: 'sb_publishable_Fhu2wqJp3sMqDlzNO_E0Mw_DpN-Ze_A',
  );

  runApp(
    ChangeNotifierProvider(create: (_)=>AuthProvider(),child:   const MyApp() ,),
 );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      home: LoginScreen(),
    );
  }
}