import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/pages/otp_screen.dart';
import 'package:mainsupabase_projuct/providers/authprovider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final emailController = TextEditingController();

  late AnimationController _orbController;
  late AnimationController _entranceController;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;
  late Animation<double> _orb1Pulse;
  late Animation<double> _orb2Pulse;
  late Animation<double> _orb1Float;
  late Animation<double> _orb2Float;

  @override
  void initState() {
    super.initState();

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _fadeIn = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.1, 0.8, curve: Curves.easeOutCubic),
    ));

    _orb1Pulse = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _orbController, curve: Curves.easeInOut),
    );

    _orb2Pulse = Tween<double>(begin: 1.1, end: 0.8).animate(
      CurvedAnimation(parent: _orbController, curve: Curves.easeInOut),
    );

    _orb1Float = Tween<double>(begin: -18, end: 18).animate(
      CurvedAnimation(parent: _orbController, curve: Curves.easeInOut),
    );

    _orb2Float = Tween<double>(begin: 14, end: -14).animate(
      CurvedAnimation(parent: _orbController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _orbController.dispose();
    _entranceController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF060714),
      body: Stack(
        children: [
          // ── Background gradient ──────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF060714),
                  Color(0xFF0A0E2A),
                  Color(0xFF06091C),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // ── Animated orb 1 — purple ──────────────────────────────────
          AnimatedBuilder(
            animation: _orbController,
            builder: (_, __) => Positioned(
              top: size.height * 0.08 + _orb1Float.value,
              left: size.width * 0.1,
              child: Transform.scale(
                scale: _orb1Pulse.value,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF7C3AED).withOpacity(0.45),
                        const Color(0xFF5B21B6).withOpacity(0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Animated orb 2 — blue ────────────────────────────────────
          AnimatedBuilder(
            animation: _orbController,
            builder: (_, __) => Positioned(
              bottom: size.height * 0.12 + _orb2Float.value,
              right: size.width * 0.05,
              child: Transform.scale(
                scale: _orb2Pulse.value,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF2563EB).withOpacity(0.4),
                        const Color(0xFF1D4ED8).withOpacity(0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Animated orb 3 — teal accent ────────────────────────────
          AnimatedBuilder(
            animation: _orbController,
            builder: (_, __) => Positioned(
              top: size.height * 0.45,
              right: -40,
              child: Transform.scale(
                scale: _orb1Pulse.value * 0.9,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF0EA5E9).withOpacity(0.25),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Main content ─────────────────────────────────────────────
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: SlideTransition(
                    position: _slideUp,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),

                        // ── Logo / Icon section ──────────────────────
                        _GlowingBrainIcon(),

                        const SizedBox(height: 28),

                        // ── Headline ─────────────────────────────────
                        const Text(
                          'Welcome back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to continue your journey',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.1,
                          ),
                        ),

                        const SizedBox(height: 36),

                        // ── Glass card ───────────────────────────────
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.09),
                                Colors.white.withOpacity(0.04),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.12),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7C3AED).withOpacity(0.08),
                                blurRadius: 40,
                                spreadRadius: -4,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // ── Email field ──────────────────────
                              _GlassTextField(controller: emailController),

                              const SizedBox(height: 16),

                              // ── Send OTP button ──────────────────
                              _GradientButton(
                                onPressed: authProvider.isLoading
                                    ? null
                                    : () async {
                                        await authProvider
                                            .sendOtp(emailController.text.trim());
                                        if (!mounted) return;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => OtpScreen(
                                                email: emailController.text
                                                    .trim()),
                                          ),
                                        );
                                      },
                                isLoading: authProvider.isLoading,
                                label: 'Continue with Email',
                              ),

                              const SizedBox(height: 20),

                              // ── Divider ──────────────────────────
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Colors.white.withOpacity(0.12),
                                      thickness: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: Text(
                                      'or',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.35),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.white.withOpacity(0.12),
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // ── Google button ────────────────────
                              _GlassGoogleButton(
                                onPressed: authProvider.isLoading
                                    ? null
                                    : () async {
                                        try {
                                          await authProvider.signInWithGoogle();
                                        } catch (e) {
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text(e.toString())));
                                        }
                                      },
                                isLoading: authProvider.isLoading,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Footer ───────────────────────────────────
                        Text(
                          'Protected by end-to-end encryption',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.25),
                            fontSize: 12,
                            letterSpacing: 0.3,
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
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

// ── Glowing AI brain icon ──────────────────────────────────────────────────

class _GlowingBrainIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow ring
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFF7C3AED).withOpacity(0.35),
                const Color(0xFF2563EB).withOpacity(0.15),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Glass container
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4F1FBF),
                Color(0xFF1D3DB5),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.18),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C3AED).withOpacity(0.5),
                blurRadius: 24,
                spreadRadius: -2,
              ),
            ],
          ),
          child: const Icon(
            Icons.psychology_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
      ],
    );
  }
}

// ── Glass email text field ─────────────────────────────────────────────────

class _GlassTextField extends StatelessWidget {
  final TextEditingController controller;

  const _GlassTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      cursorColor: const Color(0xFF7C3AED),
      decoration: InputDecoration(
        labelText: 'Email address',
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.45),
          fontSize: 14,
        ),
        hintText: 'you@example.com',
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.2),
          fontSize: 14,
        ),
        prefixIcon: Icon(
          Icons.mail_outline_rounded,
          color: Colors.white.withOpacity(0.4),
          size: 20,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFF7C3AED), width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

// ── Gradient CTA button ────────────────────────────────────────────────────

class _GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  const _GradientButton({
    required this.onPressed,
    required this.isLoading,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: onPressed == null
              ? LinearGradient(
                  colors: [
                    const Color(0xFF7C3AED).withOpacity(0.4),
                    const Color(0xFF2563EB).withOpacity(0.4),
                  ],
                )
              : const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          boxShadow: onPressed != null
              ? [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  )
                ]
              : null,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ── Glass Google button ────────────────────────────────────────────────────

class _GlassGoogleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _GlassGoogleButton({required this.onPressed, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white.withOpacity(0.06),
          border: Border.all(
            color: Colors.white.withOpacity(0.13),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Colourful G icon drawn with a custom painter
            const _GoogleLetterIcon(size: 20),
            const SizedBox(width: 10),
            Text(
              'Continue with Google',
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Google "G" icon (CustomPainter, no SVG/asset dependency) ───────────────

class _GoogleLetterIcon extends StatelessWidget {
  final double size;
  const _GoogleLetterIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleGPainter(),
    );
  }
}

class _GoogleGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final center = Offset(r, r);

    void arc(Color color, double start, double sweep, double strokeW) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r - strokeW / 2),
        start,
        sweep,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeW
          ..strokeCap = StrokeCap.butt,
      );
    }

    final sw = size.width * 0.23;
    // blue
    arc(const Color(0xFF4285F4), -0.26, 1.18, sw);
    // green
    arc(const Color(0xFF34A853), 0.92, 0.82, sw);
    // yellow
    arc(const Color(0xFFFBBC05), 1.74, 0.82, sw);
    // red
    arc(const Color(0xFFEA4335), 2.56, 1.01, sw);

    // horizontal bar of the G
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.butt;
    canvas.drawLine(
      Offset(r, r),
      Offset(size.width, r),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}