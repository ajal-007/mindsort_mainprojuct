import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_text.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_duration.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import 'otp_screen.dart';

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
      duration: AppDuration.loginOrb,
    )..repeat(reverse: true);

    _entranceController = AnimationController(
      vsync: this,
      duration: AppDuration.loginEntrance,
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
      backgroundColor: AppColors.backgroundLogin,
      body: Stack(
        children: [
          // ── Background gradient ──────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.backgroundLogin,
                  AppColors.backgroundLoginEnd,
                  AppColors.backgroundLoginStop,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // ── Animated orb 1 — purple ──────────────────────────────────
          AnimatedBuilder(
            animation: _orbController,
            builder: (context, child) => Positioned(
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
                        AppColors.loginPurpleOrb.withOpacity(0.45),
                        AppColors.loginDeepPurpleOrb.withOpacity(0.15),
                        AppColors.transparent,
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
            builder: (context, child) => Positioned(
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
                        AppColors.loginBlueOrb.withOpacity(0.4),
                        AppColors.loginDeepBlueOrb.withOpacity(0.12),
                        AppColors.transparent,
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
            builder: (context, child) => Positioned(
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
                        AppColors.loginTealOrb.withOpacity(0.25),
                        AppColors.transparent,
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
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxxl),
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: SlideTransition(
                    position: _slideUp,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: AppSizes.lg),

                          // ── Logo / Icon section ──────────────────────
                          _GlowingBrainIcon(),

                          const SizedBox(height: AppSizes.giant),

                          // ── Headline ─────────────────────────────────
                          const Text(
                            AppText.welcomeBack,
                            style: AppTextStyles.loginWelcomeTitle,
                          ),
                          const SizedBox(height: AppSizes.sm),
                          Text(
                            AppText.signInToContinue,
                            style: AppTextStyles.loginWelcomeSub,
                          ),

                          const SizedBox(height: AppSizes.superHuge),

                          // ── Glass card ───────────────────────────────
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: AppRadius.r24,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.white.withOpacity(0.09),
                                  AppColors.white.withOpacity(0.04),
                                ],
                              ),
                              border: Border.all(
                                color: AppColors.white.withOpacity(0.12),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.loginPurpleOrb.withOpacity(0.08),
                                  blurRadius: 40,
                                  spreadRadius: -4,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(AppSizes.xxxl),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // ── Email field ──────────────────────
                                _GlassTextField(controller: emailController),

                                const SizedBox(height: AppSizes.lg),

                                // ── Send OTP button ──────────────────
                                _GradientButton(
                                  onPressed: authProvider.isLoading
                                      ? null
                                      : () async {
                                          final email = emailController.text.trim();
                                          if (email.isEmpty) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text(AppText.pleaseEnterEmail),
                                                backgroundColor: AppColors.redAccent,
                                              ),
                                            );
                                            return;
                                          }
                                          try {
                                            await authProvider.sendOtp(email);
                                            if (!context.mounted) return;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => OtpScreen(email: email),
                                              ),
                                            );
                                          } catch (e) {
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(authProvider.error ?? e.toString().replaceFirst('Exception: ', '')),
                                                backgroundColor: AppColors.redAccent,
                                              ),
                                            );
                                          }
                                        },
                                  isLoading: authProvider.isLoading,
                                  label: AppText.continueWithEmail,
                                ),

                                const SizedBox(height: AppSizes.xxl),

                                // ── Divider ──────────────────────────
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: AppColors.white.withOpacity(0.12),
                                        thickness: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: AppSizes.mlg),
                                      child: Text(
                                        AppText.orLabel,
                                        style: AppTextStyles.loginOrText,
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: AppColors.white.withOpacity(0.12),
                                        thickness: 1,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: AppSizes.xxl),

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

                          const SizedBox(height: AppSizes.giant),

                          // ── Footer ───────────────────────────────────
                          Text(
                            AppText.protectedByEncryption,
                            style: AppTextStyles.loginFooter,
                          ),

                          const SizedBox(height: AppSizes.xxxl),
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
                AppColors.loginPurpleOrb.withOpacity(0.35),
                AppColors.loginBlueOrb.withOpacity(0.15),
                AppColors.transparent,
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
                AppColors.loginPurpleGradient,
                AppColors.loginBlueGradient,
              ],
            ),
            border: Border.all(
              color: AppColors.white.withOpacity(0.18),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.loginPurpleOrb.withOpacity(0.5),
                blurRadius: 24,
                spreadRadius: -2,
              ),
            ],
          ),
          child: const Icon(
            AppIcons.psychology,
            color: AppColors.white,
            size: 32,
          ),
        ),
      ],
    );
  }
}

// ── Glass email text field ─────────────────────────────────────────────────

class _GlassTextField extends StatefulWidget {
  final TextEditingController controller;

  const _GlassTextField({required this.controller});

  @override
  State<_GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<_GlassTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.emailAddress,
      style: AppTextStyles.loginTextFieldInput,
      cursorColor: AppColors.loginPurpleOrb,
      decoration: InputDecoration(
        labelText: AppText.emailAddressLabel,
        labelStyle: _isFocused
            ? AppTextStyles.loginTextFieldLabelFocused
            : AppTextStyles.loginTextFieldLabelDefault,
        hintText: AppText.emailHint,
        hintStyle: AppTextStyles.loginTextFieldHint,
        prefixIcon: Icon(
          AppIcons.mail,
          color: AppColors.white.withOpacity(0.4),
          size: 20,
        ),
        filled: true,
        fillColor: AppColors.white.withOpacity(0.06),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.r14,
          borderSide: BorderSide(color: AppColors.white.withOpacity(0.1), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.r14,
          borderSide:
              const BorderSide(color: AppColors.loginPurpleOrb, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: AppSizes.lg),
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
        duration: AppDuration.googleButtonAnim,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: AppRadius.r14,
          gradient: onPressed == null
              ? LinearGradient(
                  colors: [
                    AppColors.loginPurpleOrb.withOpacity(0.4),
                    AppColors.loginBlueOrb.withOpacity(0.4),
                  ],
                )
              : const LinearGradient(
                  colors: [AppColors.loginPurpleOrb, AppColors.loginBlueOrb],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          boxShadow: onPressed != null
              ? [
                  BoxShadow(
                    color: AppColors.loginPurpleOrb.withOpacity(0.4),
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
                    color: AppColors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(AppIcons.arrowForward,
                        color: AppColors.white, size: 18),
                    const SizedBox(width: AppSizes.sm),
                    Text(
                      label,
                      style: AppTextStyles.loginButton,
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
          borderRadius: AppRadius.r14,
          color: AppColors.white.withOpacity(0.06),
          border: Border.all(
            color: AppColors.white.withOpacity(0.13),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _GoogleLetterIcon(size: 20),
            const SizedBox(width: AppSizes.msm),
            Text(
              AppText.continueWithGoogle,
              style: AppTextStyles.loginGoogleBtn,
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
    arc(AppColors.googleBlue, -0.26, 1.18, sw);
    // green
    arc(AppColors.googleGreen, 0.92, 0.82, sw);
    // yellow
    arc(AppColors.googleYellow, 1.74, 0.82, sw);
    // red
    arc(AppColors.googleRed, 2.56, 1.01, sw);

    // horizontal bar of the G
    final barPaint = Paint()
      ..color = AppColors.googleBlue
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
