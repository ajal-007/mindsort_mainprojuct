import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/pages/complete_profile_screen.dart';
import 'package:mainsupabase_projuct/pages/home_screen.dart';
import 'package:mainsupabase_projuct/providers/authprovider.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({
    super.key,
    required this.email,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpController = TextEditingController();
 @override
void dispose() {
  otpController.dispose();
  super.dispose();
}
String maskEmail(String email) {
  final parts = email.split('@');

  if (parts.first.length <= 3) return email;

  return '${parts.first.substring(0, 3)}*****@${parts.last}';
}

  @override
  Widget build(BuildContext context) {
     final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
          "OTP sent to ${maskEmail(widget.email)}",
            ),
            

            const SizedBox(height: 20),

            TextField(
              controller: otpController,
              decoration: const InputDecoration(
                labelText: "Enter OTP",
              ),
            ),

            const SizedBox(height: 20),

          ElevatedButton(
  onPressed: authProvider.isLoading
      ? null
      : () async {
          if (otpController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please enter the OTP"),
              ),
            );
            return;
          }

          final exists = await authProvider.verifyOtp(
  email: widget.email,
  otp: otpController.text.trim(),
);

if (!mounted) return;

if (exists) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const HomeScreen(),
    ),
    (route) => false,
  );
} else {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const CompleteProfileScreen(),
    ),
    (route) => false,
  );
}
        
        },
  child: authProvider.isLoading
      ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        )
      : const Text("Verify OTP"),
)
          ],
        ),
      ),
    );
  }
}