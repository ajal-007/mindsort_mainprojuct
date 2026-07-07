import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/features/assessment/assasment_screen.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_text.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_duration.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/cyber_grid_painter.dart';
import '../../shared/widgets/glowing_orb.dart';
import 'provider/auth_provider.dart';

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

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: AppDuration.otpEntrance,
    );
    _orbController = AnimationController(
      vsync: this,
      duration: AppDuration.loginOrb,
    )..repeat(reverse: true);
    _iconController = AnimationController(
      vsync: this,
      duration: AppDuration.loginEntrance,
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
          content: const Text(AppText.enterUsernamePrompt),
          backgroundColor: AppColors.primaryAccent.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.r12,
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
          builder: (_) => const AssasmentScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      final message = e.toString().replaceFirst("Exception: ", "");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.red.withOpacity(0.85),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.r12,
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
      backgroundColor: AppColors.backgroundDark,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxxl, vertical: AppSizes.huge),
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
                          const SizedBox(height: AppSizes.huge),
                          _buildGlassCard(),
                          const SizedBox(height: AppSizes.xxl),
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
                  colors: [AppColors.backgroundDark, AppColors.surfaceDark],
                ),
              ),
            ),
            // Purple orb
            Positioned(
              top: -80 + (t * 60),
              left: -60 + (t * 30),
              child: GlowingOrb(size: 340, color: AppColors.primaryAccent, opacity: 0.18),
            ),
            // Blue orb
            Positioned(
              bottom: -100 + (t * 50),
              right: -80 + (t * 40),
              child: GlowingOrb(size: 300, color: AppColors.secondaryAccent, opacity: 0.14),
            ),
            // Grid overlay
            CustomPaint(
              painter: CyberGridPainter(color: AppColors.white.withOpacity(0.025)),
              child: const SizedBox.expand(),
            ),
          ],
        );
      },
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
                width: AppSizes.absolute,
                height: AppSizes.absolute,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryAccent.withOpacity(0.3),
                      AppColors.secondaryAccent.withOpacity(0.15),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.lightAccentGlow.withOpacity(0.35),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryAccent.withOpacity(0.25),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  AppIcons.personOutline,
                  color: AppColors.lightAccentGlow,
                  size: AppSizes.superHuge,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 22),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.textPrimary, AppColors.lightAccentGlow],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          child: const Text(
            AppText.welcomeToMindSort,
            style: AppTextStyles.completeProfileTitle,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSizes.msm),
        const Text(
          AppText.chooseUniqueUsername,
          style: AppTextStyles.completeProfileSub,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGlassCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.giant),
      decoration: BoxDecoration(
        color: AppColors.glassSurface,
        borderRadius: AppRadius.r28,
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.35),
            blurRadius: 40,
            spreadRadius: -4,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: AppColors.primaryAccent.withOpacity(0.07),
            blurRadius: 60,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUsernameField(),
          const SizedBox(height: AppSizes.msm),
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Text(
              AppText.usernameSubtitle,
              style: AppTextStyles.completeProfileFieldDesc,
            ),
          ),
          const SizedBox(height: AppSizes.xxxl),
          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildUsernameField() {
    return AnimatedContainer(
      duration: AppDuration.googleButtonAnim,
      decoration: BoxDecoration(
        borderRadius: AppRadius.r16,
        border: Border.all(
          color: _isFocused
              ? AppColors.secondaryAccent.withOpacity(0.65)
              : AppColors.border,
          width: _isFocused ? 1.5 : 1.0,
        ),
        color: AppColors.white.withOpacity(0.04),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.secondaryAccent.withOpacity(0.18),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ]
            : [],
      ),
      child: TextField(
        controller: usernameController,
        focusNode: usernameFocus,
        style: AppTextStyles.completeProfileInput,
        cursorColor: AppColors.secondaryAccent,
        decoration: InputDecoration(
          labelText: AppText.usernameLabel,
          hintText: AppText.chooseUsernameHint,
          labelStyle: TextStyle(
            color: _isFocused ? AppColors.secondaryAccent : AppColors.textSecondary,
            fontSize: AppSizes.mlg,
          ),
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.5),
            fontSize: AppSizes.mlg,
          ),
          prefixIcon: Icon(
            AppIcons.personOutline,
            color: _isFocused ? AppColors.secondaryAccent : AppColors.textSecondary,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: AppSizes.lg,
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
        duration: AppDuration.otpResendPress,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: AppRadius.r18,
            gradient: const LinearGradient(
              colors: [AppColors.primaryAccent, AppColors.completeProfileButtonEnd],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryAccent.withOpacity(0.4),
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
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimary),
                    ),
                  )
                : const Text(
                    AppText.continueButton,
                    style: AppTextStyles.completeProfileButton,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return const Text(
      AppText.changeUsernameLater,
      style: AppTextStyles.completeProfileFooter,
      textAlign: TextAlign.center,
    );
  }
}
