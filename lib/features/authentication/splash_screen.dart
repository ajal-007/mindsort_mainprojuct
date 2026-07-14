import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_text.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_duration.dart';
import '../../core/theme/app_text_styles.dart';
import '../../home_screen.dart';
import 'login_page.dart';
import 'provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<Particle> _particles = List.generate(30, (index) => Particle());

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: AppDuration.splashEntrance,
    )..repeat();

    checkSession();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> checkSession() async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.getCurrentUser();

    await Future.delayed(AppDuration.splashDelay);

    if (!mounted) return;

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSplash,
      body: Stack(
        children: [
          // 1. Futuristic Gradient Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.0, -0.2),
                  radius: 1.2,
                  colors: [
                    AppColors.backgroundSplashPurple,
                    AppColors.backgroundSplashIndigo,
                    AppColors.backgroundSplashBlack,
                  ],
                ),
              ),
            ),
          ),

          // 2. Animated Floating Particles & Neural Network Links
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: NeuralNetworkPainter(_particles, _animationController.value),
              );
            },
          ),

          // 3. Main Center UI & Tagline (Responsive Layout)
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxHeight < 550;
                return Column(
                  children: [
                    Spacer(flex: isCompact ? 1 : 2),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(isCompact ? AppSizes.xxl : AppSizes.huge),
                        margin: const EdgeInsets.symmetric(horizontal: AppSizes.xxxl),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.03),
                          borderRadius: AppRadius.r30,
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.08),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.welcomePurple.withOpacity(0.1),
                              blurRadius: 30,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            final pulse = 1.0 + (sin(_animationController.value * pi * 2) * 0.04);
                            return Transform.scale(
                              scale: pulse,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Glowing AI Brain Icon
                                  ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: [AppColors.splashPurpleGlow, AppColors.welcomeBlue],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds),
                                    child: Icon(
                                      AppIcons.psychology,
                                      size: isCompact ? 60 : AppSizes.absolute,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.lg),
                                  // MindSort Title
                                  const Text(
                                    AppText.appName,
                                    style: AppTextStyles.splashTitle,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Spacer(flex: isCompact ? 1 : 3),
                    Padding(
                      padding: EdgeInsets.only(bottom: isCompact ? AppSizes.xxl : AppSizes.massive),
                      child: Column(
                        children: [
                          // Futuristic Tagline
                          Text(
                            AppText.tagline,
                            style: AppTextStyles.splashTagline,
                          ),
                          const SizedBox(height: AppSizes.xxl),
                          // Premium Cyber Loader
                          SizedBox(
                            width: 140,
                            height: 3,
                            child: ClipRRect(
                              borderRadius: AppRadius.r12,
                              child: const LinearProgressIndicator(
                                backgroundColor: AppColors.progressBackground,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.welcomePurple),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Particle {
  double x = Random().nextDouble();
  double y = Random().nextDouble();
  double speedX = (Random().nextDouble() - 0.5) * 0.003;
  double speedY = (Random().nextDouble() - 0.5) * 0.003;
  double radius = Random().nextDouble() * 2.5 + 1;
}

class NeuralNetworkPainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  NeuralNetworkPainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.welcomePurple.withOpacity(0.25);
    final linePaint = Paint()..strokeWidth = 0.5;

    for (var p in particles) {
      p.x += p.speedX;
      p.y += p.speedY;

      if (p.x < 0 || p.x > 1) p.speedX *= -1;
      if (p.y < 0 || p.y > 1) p.speedY *= -1;

      final dx = p.x * size.width;
      final dy = p.y * size.height;

      canvas.drawCircle(Offset(dx, dy), p.radius, paint);

      for (var other in particles) {
        if (p == other) continue;
        final odx = other.x * size.width;
        final ody = other.y * size.height;
        
        final distance = sqrt(pow(dx - odx, 2) + pow(dy - ody, 2));
        if (distance < 110) {
          linePaint.color = AppColors.welcomeBlue.withOpacity((1.0 - (distance / 110)) * 0.15);
          canvas.drawLine(Offset(dx, dy), Offset(odx, ody), linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
