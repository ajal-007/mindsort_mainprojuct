import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/pages/login_page.dart';
import 'package:mainsupabase_projuct/providers/authprovider.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return  Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Home Screen"),
            ElevatedButton(onPressed: ()async{
              await authProvider.signOut();
               if (!context.mounted) return;
            Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (_) => const LoginScreen(),
  ),
  (route) => false,
);
            }, child: Text("Logout")),
          ],
        ),
      ),
    );
  }
}