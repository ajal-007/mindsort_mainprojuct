import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/pages/login_page.dart';
import 'package:mainsupabase_projuct/providers/authprovider.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _orbController;
  late final AnimationController _entranceController;
  
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;
  late final Animation<double> _orbFloat;

  bool _isLogoutPressed = false;

  // Theme colors
  static const _bg1 = Color(0xFF070B16);
  static const _bg2 = Color(0xFF111827);
  static const _accent = Color(0xFF6C63FF);
  static const _blue = Color(0xFF5EA8FF);
  static const _glow = Color(0xFF9D97FF);
  static const _glass = Color(0x0DFFFFFF);
  static const _border = Color(0x14FFFFFF);

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _fadeIn = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.1, 0.9, curve: Curves.easeOutCubic),
    ));

    _orbFloat = Tween<double>(begin: -15, end: 15).animate(
      CurvedAnimation(parent: _orbController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _orbController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      backgroundColor: _bg1,
      body: Stack(
        children: [
          // Background Gradient and Animated Orbs
          AnimatedBuilder(
            animation: _orbController,
            builder: (context, _) {
              final t = _orbController.value;
              return Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [_bg1, _bg2],
                      ),
                    ),
                  ),
                  // Animated Purple Orb
                  Positioned(
                    top: -80 + _orbFloat.value,
                    left: -60 + (t * 30),
                    child: _buildOrb(340, _accent.withOpacity(0.15)),
                  ),
                  // Animated Blue Orb
                  Positioned(
                    bottom: -100 - _orbFloat.value,
                    right: -80 + (t * 30),
                    child: _buildOrb(300, _blue.withOpacity(0.12)),
                  ),
                  // Grid Overlay
                  CustomPaint(
                    painter: _GridPainter(),
                    child: const SizedBox.expand(),
                  ),
                ],
              );
            },
          ),

          // Main Responsive Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: SlideTransition(
                    position: _slideUp,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 540),
                      child: FutureBuilder<Map<String, dynamic>?>(
                        future: authProvider.getProfile(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return _buildLoadingState();
                          }
                          
                          final profile = snapshot.data;
                          final username = profile?['username'] ?? 'Explorer';
                          final email = profile?['email'] ?? authProvider.getCurrentUser()?.email ?? '';

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildHeaderSection(username, email),
                              const SizedBox(height: 32),
                              _buildDashboardCard(),
                              const SizedBox(height: 32),
                              _buildLogoutButton(context, authProvider),
                            ],
                          );
                        },
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

  Widget _buildOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: _glass,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: _border, width: 1),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(_glow),
              strokeWidth: 3,
            ),
            SizedBox(height: 20),
            Text(
              'Loading your mental workspace...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(String username, String email) {
    final initial = username.isNotEmpty ? username[0].toUpperCase() : 'U';
    return Column(
      children: [
        // Avatar Circle
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [_accent, _blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _accent.withOpacity(0.35),
                blurRadius: 28,
                spreadRadius: 2,
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Greeting
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, _glow],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            'Hello, $username',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        // Email
        Text(
          email,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDashboardCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _glass,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 40,
            spreadRadius: -4,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _accent.withOpacity(0.25),
                  ),
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  color: _glow,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'MindSort AI Workspace',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Welcome to your command center. Your mind’s chaos is transformed here into clear actions. Start organizing, brainstorming, and letting the assistant structure your thoughts.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.55,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          // Dynamic status line
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Cloud Sync: Secured & Active',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider authProvider) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isLogoutPressed = true),
      onTapUp: (_) async {
        setState(() => _isLogoutPressed = false);
        await authProvider.signOut();
        if (!context.mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      },
      onTapCancel: () => setState(() => _isLogoutPressed = false),
      child: AnimatedScale(
        scale: _isLogoutPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white.withOpacity(0.04),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 1,
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout_rounded,
                color: Colors.redAccent,
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                'Logout Session',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFFFFF).withOpacity(0.02)
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
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}