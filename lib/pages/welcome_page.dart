
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _floatController;
  late final AnimationController _glowController;
  late final AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 6000))..repeat();
    _glowController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 4000))..repeat(reverse: true);
    _fadeController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800))..forward();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _glowController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      body: Stack(
        children: [
          _buildMeshBackground(),
          _buildGlowOrb(left: -80, top: 80, size: 280,
              color: const Color(0xFF8B5CF6), delay: 0),
          _buildGlowOrb(right: -80, bottom: 160, size: 360,
              color: const Color(0xFF00E5FF), delay: 2),
          _buildFloatingBubble(left: 40, top: 140, size: 48, delay: 0),
          _buildFloatingBubble(right: 60, top: 220, size: 32, delay: 3),
          _buildFloatingBubble(left: 70, bottom: 220, size: 24, delay: 2),
          _buildFloatingBubble(right: 50, bottom: 180, size: 40, delay: 4),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeTransition(
                          opacity: _fadeController,
                          child: _buildHeroBrain(),
                        ),
                        const SizedBox(height: 36),
                        FadeTransition(
                          opacity: _fadeController,
                          child: _buildHeadline(),
                        ),
                        const SizedBox(height: 20),
                        FadeTransition(
                          opacity: _fadeController,
                          child: Text(
                            'Brain dump your thoughts, organize what matters, and let AI guide your next step.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              height: 1.55,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FadeTransition(
                    opacity: _fadeController,
                    child: _buildActions(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeshBackground() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0B1020),
        gradient: RadialGradient(
          center: Alignment(-0.6, -0.6),
          radius: 1.2,
          colors: [Color(0x158B5CF6), Color(0x000B1020)],
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.6, 0.6),
            radius: 1.0,
            colors: [Color(0x1200E5FF), Color(0x000B1020)],
          ),
        ),
      ),
    );
  }

  Widget _buildGlowOrb({double? left, double? right, double? top,
      double? bottom, required double size, required Color color,
      required double delay}) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final shifted = (delay / 4 + _glowController.value) % 1.0;
        final opacity = 0.25 + shifted * 0.35;
        return Positioned(
          left: left, right: right, top: top, bottom: bottom,
          child: Container(
            width: size, height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(opacity),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(opacity * 0.5),
                  blurRadius: 80,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingBubble({double? left, double? right, double? top,
      double? bottom, required double size, required double delay}) {
    final offset = delay / 6;
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final value = _floatController.value + offset;
      final y = sin(value * 2 * 3.14159) * 14;
final rotation = sin(value * 2 * 3.14159) * 0.04;
        return Positioned(
          left: left, right: right, top: top, bottom: bottom,
          child: Transform.translate(
            offset: Offset(0, y),
            child: Transform.rotate(
              angle: rotation,
              child: ClipOval(
                child: BackdropFilter(
                  filter:  ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF141B34).withOpacity(0.6),
                      border: Border.all(color: Colors.white.withOpacity(0.12)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroBrain() {
    return SizedBox(
      width: 260,
      height: 260,
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [
                  Color(0x4D8B5CF6),
                  Color(0x333B82F6),
                  Color(0x1A00E5FF),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B5CF6)
                      .withOpacity(0.3 + _glowController.value * 0.2),
                  blurRadius: 80 + _glowController.value * 20,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/brain.jpg',
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeadline() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(
          fontFamily: 'Space Grotesk',
          fontSize: 40,
          fontWeight: FontWeight.w700,
          height: 1.08,
          color: Colors.white,
        ),
        children: [
          TextSpan(text: 'Turn Mental Chaos Into '),
          TextSpan(
            text: 'Clear Action',
            style: TextStyle(color: Color(0xFF00E5FF)),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6), Color(0xFF06B6D4)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withOpacity(0.4),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(28),
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: () { /* Navigate to next onboarding screen */ },
              child: const Center(
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter:  ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              width: double.infinity,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: const Color(0xFF141B34).withOpacity(0.6),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(28),
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: () { /* Google sign-in */ },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 20, height: 20, child: _GoogleIcon()),
                      SizedBox(width: 12),
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        
      ],
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(20, 20), painter: _GoogleIconPainter());
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(size.width * 0.5, size.height * 0.2)
      ..lineTo(size.width * 0.78, size.height * 0.2)
      ..lineTo(size.width * 0.6, size.height * 0.5)
      ..lineTo(size.width * 0.78, size.height * 0.8)
      ..lineTo(size.width * 0.5, size.height * 0.8)
      ..lineTo(size.width * 0.2, size.height * 0.5)
      ..close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
