import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_duration.dart';
import '../../core/theme/app_text_styles.dart';
import 'login_page.dart';

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
      vsync: this, duration: AppDuration.welcomeFloat)..repeat();
    _glowController = AnimationController(
      vsync: this, duration: AppDuration.welcomeGlow)..repeat(reverse: true);
    _fadeController = AnimationController(
      vsync: this, duration: AppDuration.welcomeFade)..forward();
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
      backgroundColor: AppColors.backgroundWelcome,
      body: Stack(
        children: [
          _buildMeshBackground(),
          _buildGlowOrb(left: -80, top: 80, size: 280,
              color: AppColors.welcomePurple, delay: 0),
          _buildGlowOrb(right: -80, bottom: 160, size: 360,
              color: AppColors.welcomeTeal, delay: 2),
          _buildFloatingBubble(left: 40, top: 140, size: AppSizes.colossus, delay: 0),
          _buildFloatingBubble(right: 60, top: 220, size: AppSizes.huge, delay: 3),
          _buildFloatingBubble(left: 70, bottom: 220, size: AppSizes.xxxl, delay: 2),
          _buildFloatingBubble(right: 50, bottom: 180, size: AppSizes.massive, delay: 4),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.xxxl,
                          vertical: AppSizes.huge,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 420),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FadeTransition(
                                        opacity: _fadeController,
                                        child: _buildHeroBrain(),
                                      ),
                                      const SizedBox(height: AppSizes.superHuge),
                                      FadeTransition(
                                        opacity: _fadeController,
                                        child: _buildHeadline(),
                                      ),
                                      const SizedBox(height: AppSizes.xxl),
                                      FadeTransition(
                                        opacity: _fadeController,
                                        child: Text(
                                          AppText.welcomeSub,
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.welcomeSub,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppSizes.xxxl),
                                FadeTransition(
                                  opacity: _fadeController,
                                  child: _buildActions(),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeshBackground() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundWelcome,
        gradient: RadialGradient(
          center: Alignment(-0.6, -0.6),
          radius: 1.2,
          colors: [Color(0x158B5CF6), AppColors.transparent],
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.6, 0.6),
            radius: 1.0,
            colors: [Color(0x1200E5FF), AppColors.transparent],
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
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.welcomeBubble.withOpacity(0.6),
                      border: Border.all(color: AppColors.white.withOpacity(0.12)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.3),
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
    final size = MediaQuery.of(context).size;
    final brainSize = size.height < 600 ? 160.0 : 260.0;
    return SizedBox(
      width: brainSize,
      height: brainSize,
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
                  AppColors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.welcomePurple
                      .withOpacity(0.3 + _glowController.value * 0.2),
                  blurRadius: 80 + _glowController.value * 20,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Image.asset(
              AppAssets.brain,
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
      text: TextSpan(
        style: AppTextStyles.welcomeHeadline,
        children: const [
          TextSpan(text: AppText.turnMentalChaos),
          TextSpan(
            text: AppText.clearAction,
            style: TextStyle(color: AppColors.welcomeTeal),
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
          height: AppSizes.behemoth,
          decoration: BoxDecoration(
            borderRadius: AppRadius.r28,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.welcomePurple, AppColors.welcomeBlue, AppColors.welcomeCyan],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.welcomePurple.withOpacity(0.4),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: AppColors.transparent,
            borderRadius: AppRadius.r28,
            child: InkWell(
              borderRadius: AppRadius.r28,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Center(
                child: Text(
                  AppText.getStarted,
                  style: AppTextStyles.welcomeBtnGetStarted,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.mlg),
        ClipRRect(
          borderRadius: AppRadius.r28,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              width: double.infinity,
              height: AppSizes.behemoth,
              decoration: BoxDecoration(
                borderRadius: AppRadius.r28,
                color: AppColors.welcomeBubble.withOpacity(0.6),
                border: Border.all(color: AppColors.white.withOpacity(0.12)),
              ),
              child: Material(
                color: AppColors.transparent,
                borderRadius: AppRadius.r28,
                child: InkWell(
                  borderRadius: AppRadius.r28,
                  onTap: () { /* Google sign-in */ },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: AppSizes.xxl, height: AppSizes.xxl, child: _GoogleIcon()),
                      SizedBox(width: AppSizes.md),
                      Text(
                        AppText.continueWithGoogle,
                        style: AppTextStyles.welcomeBtnGoogle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.xxxl),
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
      ..color = AppColors.white
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
