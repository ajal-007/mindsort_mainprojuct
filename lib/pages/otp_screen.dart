import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mainsupabase_projuct/pages/complete_profile_screen.dart';
import 'package:mainsupabase_projuct/navigation/home_screen.dart';
import 'package:mainsupabase_projuct/providers/authprovider.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with TickerProviderStateMixin {
  final otpController = TextEditingController();
  final focusNode = FocusNode();
  bool _isFocused = false;
  bool _isPressed = false;
  bool _isResending = false;

  late AnimationController _entranceController;
  late AnimationController _orbController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _orbAnim;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );
    _orbAnim = CurvedAnimation(parent: _orbController, curve: Curves.easeInOut);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _entranceController.forward();

    focusNode.addListener(() {
      setState(() => _isFocused = focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    focusNode.dispose();
    _entranceController.dispose();
    _orbController.dispose();
    _pulseController.dispose();
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF070B16),
      body: Stack(
        children: [
          // Animated background orbs
          AnimatedBuilder(
            animation: _orbAnim,
            builder: (_, __) {
              final t = _orbAnim.value;
              return Stack(
                children: [
                  Positioned(
                    top: -80 + (t * 40),
                    left: -60 + (t * 30),
                    child: _GlowOrb(
                      color: const Color(0xFF6C63FF),
                      size: 320,
                      opacity: 0.18 + (t * 0.07),
                    ),
                  ),
                  Positioned(
                    bottom: -60 + (t * 30),
                    right: -80 + (t * 20),
                    child: _GlowOrb(
                      color: const Color(0xFF5EA8FF),
                      size: 280,
                      opacity: 0.14 + (t * 0.06),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.4 + (t * 20),
                    left: size.width * 0.6,
                    child: _GlowOrb(
                      color: const Color(0xFF9D97FF),
                      size: 180,
                      opacity: 0.08 + (t * 0.04),
                    ),
                  ),
                ],
              );
            },
          ),

          // Subtle grid overlay
          CustomPaint(
            size: Size(size.width, size.height),
            painter: _GridPainter(),
          ),

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Glowing icon
                          AnimatedBuilder(
                            animation: _pulseAnim,
                            builder: (_, __) => Transform.scale(
                              scale: _pulseAnim.value,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF6C63FF),
                                      Color(0xFF5EA8FF),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF6C63FF,
                                      ).withOpacity(0.5),
                                      blurRadius: 28,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.15),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.verified_user_rounded,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Gradient title
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Colors.white, Color(0xFF9D97FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: const Text(
                              "Verify your email",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "We've sent a 8-digit verification code.",
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color(0xFF9CA3AF),
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 8),

                          // Masked email chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C63FF).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(
                                  0xFF6C63FF,
                                ).withOpacity(0.25),
                              ),
                            ),
                            child: Text(
                              maskEmail(widget.email),
                              style: const TextStyle(
                                color: Color(0xFF9D97FF),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Glass card
                          _GlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // OTP Input
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: _isFocused
                                          ? const Color(
                                              0xFF5EA8FF,
                                            ).withOpacity(0.6)
                                          : Colors.white.withOpacity(0.08),
                                      width: _isFocused ? 1.5 : 1,
                                    ),
                                    boxShadow: _isFocused
                                        ? [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF5EA8FF,
                                              ).withOpacity(0.15),
                                              blurRadius: 20,
                                              spreadRadius: 2,
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: TextField(
                                    controller: otpController,
                                    focusNode: focusNode,
                                    keyboardType: TextInputType.number,
                                    maxLength: 8,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 4,
                                    ),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      labelText: "Verification Code",
                                      hintText: "Enter 8-digit code",
                                      hintStyle: TextStyle(
                                        color: const Color(
                                          0xFF9CA3AF,
                                        ).withOpacity(0.5),
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                      labelStyle: TextStyle(
                                        color: _isFocused
                                            ? const Color(0xFF5EA8FF)
                                            : const Color(0xFF9CA3AF),
                                        fontSize: 14,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.password_rounded,
                                        color: _isFocused
                                            ? const Color(0xFF5EA8FF)
                                            : const Color(0xFF9CA3AF),
                                        size: 20,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 18,
                                          ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Verify button
                                GestureDetector(
                                  onTapDown: (_) =>
                                      setState(() => _isPressed = true),
                                  onTapUp: (_) =>
                                      setState(() => _isPressed = false),
                                  onTapCancel: () =>
                                      setState(() => _isPressed = false),
                                  onTap: authProvider.isLoading
                                      ? null
                                      : () async {
                                          if (otpController.text
                                              .trim()
                                              .isEmpty) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Please enter the OTP",
                                                ),
                                              ),
                                            );
                                            return;
                                          }

                                          try {
                                            final exists = await authProvider
                                                .verifyOtp(
                                                  email: widget.email,
                                                  otp: otpController.text
                                                      .trim(),
                                                );

                                            if (!context.mounted) return;

                                            if (exists) {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const HomeScreen(),
                                                ),
                                                (route) => false,
                                              );
                                            } else {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const CompleteProfileScreen(),
                                                ),
                                                (route) => false,
                                              );
                                            }
                                          } catch (e) {
                                            if (!context.mounted) return;

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  authProvider.error ??
                                                      "OTP verification failed",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                  child: AnimatedScale(
                                    scale: _isPressed ? 0.97 : 1.0,
                                    duration: const Duration(milliseconds: 120),
                                    child: Container(
                                      height: 56,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        gradient: LinearGradient(
                                          colors: authProvider.isLoading
                                              ? [
                                                  const Color(
                                                    0xFF6C63FF,
                                                  ).withOpacity(0.5),
                                                  const Color(
                                                    0xFF4F46E5,
                                                  ).withOpacity(0.5),
                                                ]
                                              : const [
                                                  Color(0xFF6C63FF),
                                                  Color(0xFF4F46E5),
                                                ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        boxShadow: authProvider.isLoading
                                            ? []
                                            : [
                                                BoxShadow(
                                                  color: const Color(
                                                    0xFF6C63FF,
                                                  ).withOpacity(0.4),
                                                  blurRadius: 20,
                                                  spreadRadius: 1,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                      ),
                                      alignment: Alignment.center,
                                      child: authProvider.isLoading
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text(
                                              "Verify OTP",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Resend section
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Didn't receive the code?  ",
                                      style: TextStyle(
                                        color: const Color(0xFF9CA3AF),
                                        fontSize: 13,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _isResending
                                          ? null
                                          : () async {
                                              setState(() => _isResending = true);
                                              try {
                                                await authProvider.resendOtp(
                                                  widget.email,
                                                );

                                                if (!context.mounted) return;

                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "A new OTP has been sent.",
                                                    ),
                                                  ),
                                                );
                                              } catch (_) {
                                                if (!context.mounted) return;

                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      authProvider.error ??
                                                          "Failed to resend OTP",
                                                    ),
                                                  ),
                                                );
                                              } finally {
                                                if (mounted) {
                                                  setState(() => _isResending = false);
                                                }
                                              }
                                            },
                                      child: Text(
                                        _isResending ? "Resending..." : "Resend Code",
                                        style: TextStyle(
                                          color: _isResending ? const Color(0xFF9CA3AF) : const Color(0xFF9D97FF),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          decoration: _isResending ? TextDecoration.none : TextDecoration.underline,
                                          decorationColor: const Color(0xFF9D97FF),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Footer
                          Text(
                            "Verification helps keep your MindSort account secure.",
                            style: TextStyle(
                              color: const Color(0xFF9CA3AF).withOpacity(0.6),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 40,
            spreadRadius: 4,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.05),
            blurRadius: 60,
            spreadRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;

  const _GlowOrb({
    required this.color,
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(opacity),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(opacity * 1.5),
              blurRadius: size * 0.6,
              spreadRadius: size * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.022)
      ..strokeWidth = 0.5;

    const spacing = 48.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
