import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/providers/authprovider.dart';
import 'package:provider/provider.dart';
import 'package:mainsupabase_projuct/navigation/home_screen.dart';
 
class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});
 
  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}
 
class _CompleteProfileScreenState extends State<CompleteProfileScreen>
    with TickerProviderStateMixin {
  final usernameController = TextEditingController();
  final usernameFocus = FocusNode();
 
  bool _isLoading = false;
  bool _isFocused = false;
  bool _isPressed = false;
 
  late final AnimationController _entranceController;
  late final AnimationController _orbController;
  late final AnimationController _iconController;
 
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _iconBounce;
 
  // Colors
  static const _bg1 = Color(0xFF070B16);
  static const _bg2 = Color(0xFF111827);
  static const _accent = Color(0xFF6C63FF);
  static const _glow = Color(0xFF9D97FF);
  static const _blue = Color(0xFF5EA8FF);
  static const _textPrimary = Color(0xFFFFFFFF);
  static const _textSecondary = Color(0xFF9CA3AF);
  static const _glass = Color(0x0DFFFFFF);
  static const _border = Color(0x14FFFFFF);
 
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
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
 
    _fadeAnim = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.1, 0.8, curve: Curves.easeOutCubic),
    ));
    _iconBounce = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );
 
    _entranceController.forward();
 
    usernameFocus.addListener(() {
      setState(() => _isFocused = usernameFocus.hasFocus);
    });
  }
 
  @override
  void dispose() {
    usernameController.dispose();
    usernameFocus.dispose();
    _entranceController.dispose();
    _orbController.dispose();
    _iconController.dispose();
    super.dispose();
  }
 
 Future<void> _handleContinue() async {
  if (_isLoading) return;

  final authProvider = context.read<AuthProvider>();
  final username = usernameController.text.trim();

  if (username.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Please enter a username"),
        backgroundColor: _accent.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
    return;
  }

  setState(() => _isLoading = true);

  try {
    await authProvider.createProfile(username: username);

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
      (route) => false,
    );
  } catch (e) {
    if (!mounted) return;

    final message = e.toString().replaceFirst("Exception: ", "");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.withOpacity(0.85),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg1,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildIconSection(),
                          const SizedBox(height: 32),
                          _buildGlassCard(),
                          const SizedBox(height: 20),
                          _buildFooter(),
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
 
  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _orbController,
      builder: (context, _) {
        final t = _orbController.value;
        return Stack(
          children: [
            // Base gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_bg1, _bg2],
                ),
              ),
            ),
            // Purple orb
            Positioned(
              top: -80 + (t * 60),
              left: -60 + (t * 30),
              child: _buildOrb(340, _accent.withOpacity(0.18)),
            ),
            // Blue orb
            Positioned(
              bottom: -100 + (t * 50),
              right: -80 + (t * 40),
              child: _buildOrb(300, _blue.withOpacity(0.14)),
            ),
            // Grid overlay
            CustomPaint(
              painter: _GridPainter(),
              child: const SizedBox.expand(),
            ),
          ],
        );
      },
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
 
  Widget _buildIconSection() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _iconBounce,
          builder: (context, _) {
            final offset = math.sin(_iconBounce.value * math.pi) * 4;
            return Transform.translate(
              offset: Offset(0, offset),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _accent.withOpacity(0.3),
                      _blue.withOpacity(0.15),
                    ],
                  ),
                  border: Border.all(
                    color: _glow.withOpacity(0.35),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _accent.withOpacity(0.25),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: _glow,
                  size: 36,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 22),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [_textPrimary, _glow],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          child: const Text(
            'Welcome to MindSort',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Choose a unique username to personalize\nyour AI workspace.',
          style: TextStyle(
            fontSize: 14,
            color: _textSecondary,
            height: 1.55,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
 
  Widget _buildGlassCard() {
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
          BoxShadow(
            color: _accent.withOpacity(0.07),
            blurRadius: 60,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUsernameField(),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Text(
              'This username will be visible inside your MindSort profile.',
              style: TextStyle(
                fontSize: 12,
                color: _textSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildContinueButton(),
        ],
      ),
    );
  }
 
  Widget _buildUsernameField() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isFocused
              ? _blue.withOpacity(0.65)
              : _border,
          width: _isFocused ? 1.5 : 1.0,
        ),
        color: Colors.white.withOpacity(0.04),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: _blue.withOpacity(0.18),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ]
            : [],
      ),
      child: TextField(
        controller: usernameController,
        focusNode: usernameFocus,
        style: const TextStyle(
          color: _textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        cursorColor: _blue,
        decoration: InputDecoration(
          labelText: 'Username',
          hintText: 'Choose a username',
          labelStyle: TextStyle(
            color: _isFocused ? _blue : _textSecondary,
            fontSize: 14,
          ),
          hintStyle: TextStyle(
            color: _textSecondary.withOpacity(0.5),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.person_outline_rounded,
            color: _isFocused ? _blue : _textSecondary,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
 
  Widget _buildContinueButton() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _handleContinue();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [_accent, Color(0xFF4338CA)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _accent.withOpacity(0.4),
                blurRadius: 24,
                spreadRadius: -2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(_textPrimary),
                    ),
                  )
                : const Text(
                    'Continue',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
 
  Widget _buildFooter() {
    return const Text(
      'You can change your username later from Settings.',
      style: TextStyle(
        fontSize: 12,
        color: Color(0xFF6B7280),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }
}
 
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFFFFF).withOpacity(0.025)
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