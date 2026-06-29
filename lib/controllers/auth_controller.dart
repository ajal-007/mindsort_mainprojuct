// import 'package:flutter/material.dart';
// import 'package:mainsupabase_projuct/pages/complete_profile_screen.dart';
// import 'package:mainsupabase_projuct/pages/home_screen.dart';
// import '../pages/otp_screen.dart';
// import '../providers/authprovider.dart';

// class AuthController {
//   Future<void> sendOtp({
//     required BuildContext context,
//     required AuthProvider provider,
//     required String email,
//   }) async {
//     try {
//       await provider.sendOtp(email);

//       if (!context.mounted) return;

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => OtpScreen(email: email),
//         ),
//       );
//     } catch (e) {
//       if (!context.mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(e.toString()),
//         ),
//       );
//     }
//   }
  
//   Future<void> verifyOtp({
//     required BuildContext context,
//     required AuthProvider provider,
//     required String email,
//     required String otp,
//   }) async {
//     try {
//       final profileExists = await provider.verifyOtp(
//         email: email,
//         otp: otp,
//       );

//       if (!context.mounted) return;

//       if (profileExists) {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (_) => const HomeScreen(),
//           ),
//           (route) => false,
//         );
//       } else {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (_) => const CompleteProfileScreen(),
//           ),
//           (route) => false,
//         );
//       }
//     } catch (e) {
//       if (!context.mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(e.toString()),
//         ),
//       );
//     }
//   }
// }