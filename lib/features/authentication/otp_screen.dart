import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../home_screen.dart';
import 'complete_profile_screen.dart';

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
      duration: AppDuration.otpEntrance,
    );
    _orbController = AnimationController(
      vsync: this,
      duration: AppDuration.loginOrb,
    )..repeat(reverse: true);
    _pulseController = AnimationController(
      vsync: this,
      duration: AppDuration.otpPulse,
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
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Animated background orbs
          AnimatedBuilder(
            animation: _orbAnim,
            builder: (context, child) {
              final t = _orbAnim.value;
              return Stack(
                children: [
                  Positioned(
                    top: -80 + (t * 40),
                    left: -60 + (t * 30),
                    child: GlowingOrb(
                      color: AppColors.primaryAccent,
                      size: 320,
                      opacity: 0.18 + (t * 0.07),
                      useRadialGradient: false,
                    ),
                  ),
                  Positioned(
                    bottom: -60 + (t * 30),
                    right: -80 + (t * 20),
                    child: GlowingOrb(
                      color: AppColors.secondaryAccent,
                      size: 280,
                      opacity: 0.14 + (t * 0.06),
                      useRadialGradient: false,
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.4 + (t * 20),
                    left: size.width * 0.6,
                    child: GlowingOrb(
                      color: AppColors.lightAccentGlow,
                      size: 180,
                      opacity: 0.08 + (t * 0.04),
                      useRadialGradient: false,
                    ),
                  ),
                ],
              );
            },
          ),

          // Subtle grid overlay
          CustomPaint(
            size: Size(size.width, size.height),
            painter: CyberGridPainter(
              color: AppColors.white.withOpacity(0.022),
            ),
          ),

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.xxxl,
                  vertical: AppSizes.huge,
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
                            builder: (context, child) => Transform.scale(
                              scale: _pulseAnim.value,
                              child: Container(
                                width: AppSizes.absolute,
                                height: AppSizes.absolute,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.primaryAccent,
                                      AppColors.secondaryAccent,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryAccent.withOpacity(0.5),
                                      blurRadius: 28,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                  border: Border.all(
                                    color: AppColors.white.withOpacity(0.15),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  AppIcons.verifiedUser,
                                  color: AppColors.white,
                                  size: AppSizes.superHuge,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: AppSizes.giant),

                          // Gradient title
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [AppColors.white, AppColors.lightAccentGlow],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: const Text(
                              AppText.verifyEmailTitle,
                              style: AppTextStyles.otpTitle,
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: AppSizes.msm),

                          const Text(
                            AppText.sentCodeSub,
                            style: AppTextStyles.otpSub,
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: AppSizes.sm),

                          // Masked email chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.mlg,
                              vertical: AppSizes.sxs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryAccent.withOpacity(0.12),
                              borderRadius: AppRadius.r20,
                              border: Border.all(
                                color: AppColors.primaryAccent.withOpacity(0.25),
                              ),
                            ),
                            child: Text(
                              maskEmail(widget.email),
                              style: AppTextStyles.otpChip,
                            ),
                          ),

                          const SizedBox(height: AppSizes.huge),

                          // Glass card
                          _GlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // OTP Input
                                AnimatedContainer(
                                  duration: AppDuration.googleButtonAnim,
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withOpacity(0.05),
                                    borderRadius: AppRadius.r18,
                                    border: Border.all(
                                      color: _isFocused
                                          ? AppColors.secondaryAccent.withOpacity(0.6)
                                          : AppColors.white.withOpacity(0.08),
                                      width: _isFocused ? 1.5 : 1,
                                    ),
                                    boxShadow: _isFocused
                                        ? [
                                            BoxShadow(
                                              color: AppColors.secondaryAccent.withOpacity(0.15),
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
                                    style: AppTextStyles.otpInput,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      labelText: AppText.verificationCodeLabel,
                                      hintText: AppText.enterOtpHint,
                                      hintStyle: AppTextStyles.otpHint,
                                      labelStyle: TextStyle(
                                        color: _isFocused
                                            ? AppColors.secondaryAccent
                                            : AppColors.textSecondary,
                                        fontSize: AppSizes.mlg,
                                      ),
                                      prefixIcon: Icon(
                                        AppIcons.password,
                                        color: _isFocused
                                            ? AppColors.secondaryAccent
                                            : AppColors.textSecondary,
                                        size: 20,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: AppSizes.lg,
                                            vertical: AppSizes.xl,
                                          ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: AppSizes.xxxl),

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
                                                  AppText.enterOtpError,
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
                                                      AppText.verificationFailed,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                  child: AnimatedScale(
                                    scale: _isPressed ? 0.97 : 1.0,
                                    duration: AppDuration.otpVerifyPress,
                                    child: Container(
                                      height: 56,
                                      decoration: BoxDecoration(
                                        borderRadius: AppRadius.r18,
                                        gradient: LinearGradient(
                                          colors: authProvider.isLoading
                                              ? [
                                                  AppColors.primaryAccent.withOpacity(0.5),
                                                  AppColors.buttonAccentEnd.withOpacity(0.5),
                                                ]
                                              : const [
                                                  AppColors.primaryAccent,
                                                  AppColors.buttonAccentEnd,
                                                ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        boxShadow: authProvider.isLoading
                                            ? []
                                            : [
                                                BoxShadow(
                                                  color: AppColors.primaryAccent.withOpacity(0.4),
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
                                                color: AppColors.white,
                                              ),
                                            )
                                          : const Text(
                                              AppText.verifyOtpBtn,
                                              style: AppTextStyles.otpVerifyBtn,
                                            ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: AppSizes.xxl),

                                // Resend section
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      AppText.didntReceiveCode,
                                      style: AppTextStyles.otpResendLabel,
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
                                                      AppText.otpSentSuccess,
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
                                                          AppText.otpResendFailed,
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
                                        _isResending ? AppText.resending : AppText.resendCode,
                                        style: _isResending
                                            ? AppTextStyles.otpResendingBtn
                                            : AppTextStyles.otpResendBtn,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: AppSizes.giant),

                          // Footer
                          Text(
                            AppText.secureVerificationFooter,
                            style: AppTextStyles.otpFooter,
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
      padding: const EdgeInsets.all(AppSizes.giant),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.04),
        borderRadius: AppRadius.r28,
        border: Border.all(color: AppColors.white.withOpacity(0.08), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.4),
            blurRadius: 40,
            spreadRadius: 4,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: AppColors.primaryAccent.withOpacity(0.05),
            blurRadius: 60,
            spreadRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }
}
