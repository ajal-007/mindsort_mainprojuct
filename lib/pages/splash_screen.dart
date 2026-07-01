import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mainsupabase_projuct/pages/login_page.dart'; // Keep your existing imports
import 'home_screen.dart';

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
    
    // Controller for pulsing neural network and floating particles
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    checkSession();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> checkSession() async {
    final user = Supabase.instance.client.auth.currentUser;

    // Minimum display time for the beautiful splash effects
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()), // Adjusted to match your import name if needed
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0915), // Deep space/cyber background
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
                    Color(0xFF3B1A55), // Deep Purple glow
                    Color(0xFF0F1026), // Deep Indigo
                    Color(0xFF05050B), // Near Black
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
                        padding: EdgeInsets.all(isCompact ? 20 : 32),
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withOpacity(0.1),
                              blurRadius: 30,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            // Pulsing scale effect
                            final pulse = 1.0 + (sin(_animationController.value * pi * 2) * 0.04);
                            return Transform.scale(
                              scale: pulse,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Glowing AI Brain Icon
                                  ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: [Color(0xFFA78BFA), Color(0xFF3B82F6)], // Purple to Blue
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds),
                                    child: Icon(
                                      Icons.psychology_rounded, // AI Brain Icon
                                      size: isCompact ? 60 : 80,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: isCompact ? 10 : 16),
                                  // MindSort Title
                                  Text(
                                    'MindSort',
                                    style: TextStyle(
                                      fontSize: isCompact ? 26 : 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 3.5,
                                      shadows: const [
                                        Shadow(
                                          color: Color(0xFF8B5CF6),
                                          blurRadius: 15,
                                        ),
                                      ],
                                    ),
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
                      padding: EdgeInsets.only(bottom: isCompact ? 20 : 40),
                      child: Column(
                        children: [
                          // Futuristic Tagline
                          Text(
                            'Organize Your Mind. Take Action.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: isCompact ? 12 : 14,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Premium Cyber Loader
                          SizedBox(
                            width: 140,
                            height: 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: const LinearProgressIndicator(
                                backgroundColor: Color(0xFF1E1E38),
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
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

// Custom Physics Core for the background particle network
class Particle {
  double x = Random().nextDouble();
  double y = Random().nextDouble();
  double speedX = (Random().nextDouble() - 0.5) * 0.003;
  double speedY = (Random().nextDouble() - 0.5) * 0.003;
  double radius = Random().nextDouble() * 2.5 + 1;
}

// Custom Painter to connect particles dynamically via neural-style lines
class NeuralNetworkPainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  NeuralNetworkPainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF8B5CF6).withOpacity(0.25);
    final linePaint = Paint()..strokeWidth = 0.5;

    // Update positions and draw particles
    for (var p in particles) {
      p.x += p.speedX;
      p.y += p.speedY;

      // Screen boundary bounces
      if (p.x < 0 || p.x > 1) p.speedX *= -1;
      if (p.y < 0 || p.y > 1) p.speedY *= -1;

      final dx = p.x * size.width;
      final dy = p.y * size.height;

      canvas.drawCircle(Offset(dx, dy), p.radius, paint);

      // Draw dynamic lines to nearby nodes creating a neural network effect
      for (var other in particles) {
        if (p == other) continue;
        final odx = other.x * size.width;
        final ody = other.y * size.height;
        
        final distance = sqrt(pow(dx - odx, 2) + pow(dy - ody, 2));
        if (distance < 110) {
          linePaint.color = const Color(0xFF3B82F6).withOpacity((1.0 - (distance / 110)) * 0.15);
          canvas.drawLine(Offset(dx, dy), Offset(odx, ody), linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}