import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';

class AppTextStyles {
  // Splash & Welcome Screen
  static const welcomeHeadline = TextStyle(
    fontFamily: 'Space Grotesk',
    fontSize: AppFontSizes.displayLarge,
    fontWeight: AppFontWeights.bold,
    height: 1.08,
    color: AppColors.white,
  );
  
  static final welcomeSub = TextStyle(
    fontFamily: 'Inter',
    fontSize: AppFontSizes.bodyLarge,
    height: 1.55,
    color: AppColors.white.withOpacity(0.6),
  );
  
  static const welcomeBtnGetStarted = TextStyle(
    fontFamily: 'Inter',
    fontSize: AppFontSizes.button,
    fontWeight: AppFontWeights.semiBold,
    color: AppColors.white,
  );
  
  static const welcomeBtnGoogle = TextStyle(
    fontFamily: 'Inter',
    fontSize: AppFontSizes.bodyLarge,
    fontWeight: AppFontWeights.medium,
    color: AppColors.white,
  );

  // Login Screen
  static const loginWelcomeTitle = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.displaySmall,
    fontWeight: AppFontWeights.bold,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static final loginWelcomeSub = TextStyle(
    color: AppColors.white.withOpacity(0.45),
    fontSize: AppFontSizes.bodyMedium,
    fontWeight: AppFontWeights.normal,
    letterSpacing: 0.1,
  );

  static final loginOrText = TextStyle(
    color: AppColors.white.withOpacity(0.35),
    fontSize: AppFontSizes.bodySmall,
    fontWeight: AppFontWeights.medium,
    letterSpacing: 0.5,
  );

  static final loginFooter = TextStyle(
    color: AppColors.white.withOpacity(0.25),
    fontSize: AppFontSizes.captionLarge,
    letterSpacing: 0.3,
  );

  static const loginTextFieldInput = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.bodyMedium,
    fontWeight: AppFontWeights.normal,
  );

  static final loginTextFieldLabelDefault = TextStyle(
    color: AppColors.white.withOpacity(0.45),
    fontSize: AppFontSizes.body,
  );

  static const loginTextFieldLabelFocused = TextStyle(
    color: AppColors.loginPurpleOrb,
    fontSize: AppFontSizes.body,
  );

  static final loginTextFieldHint = TextStyle(
    color: AppColors.white.withOpacity(0.2),
    fontSize: AppFontSizes.body,
  );

  static const loginButton = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.bodyMedium,
    fontWeight: AppFontWeights.semiBold,
    letterSpacing: 0.2,
  );

  static final loginGoogleBtn = TextStyle(
    color: AppColors.white.withOpacity(0.85),
    fontSize: AppFontSizes.bodyMedium,
    fontWeight: AppFontWeights.medium,
    letterSpacing: 0.1,
  );

  // OTP Screen
  static const otpTitle = TextStyle(
    fontSize: AppFontSizes.displaySmall,
    fontWeight: AppFontWeights.bold,
    color: AppColors.white,
    letterSpacing: -0.5,
  );

  static const otpSub = TextStyle(
    fontSize: AppFontSizes.bodyMedium,
    color: AppColors.textSecondary,
    fontWeight: AppFontWeights.normal,
  );

  static const otpChip = TextStyle(
    color: AppColors.lightAccentGlow,
    fontSize: AppFontSizes.bodySmall,
    fontWeight: AppFontWeights.medium,
    letterSpacing: 0.2,
  );

  static const otpInput = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.bodyLarge,
    fontWeight: AppFontWeights.medium,
    letterSpacing: 4,
  );

  static final otpHint = TextStyle(
    color: AppColors.textSecondary.withOpacity(0.5),
    letterSpacing: 1,
    fontWeight: AppFontWeights.normal,
    fontSize: AppFontSizes.body,
  );

  static const otpVerifyBtn = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.bodyLarge,
    fontWeight: AppFontWeights.semiBold,
    letterSpacing: 0.3,
  );

  static const otpResendLabel = TextStyle(
    color: AppColors.textSecondary,
    fontSize: AppFontSizes.bodySmall,
  );

  static const otpResendBtn = TextStyle(
    color: AppColors.lightAccentGlow,
    fontSize: AppFontSizes.bodySmall,
    fontWeight: AppFontWeights.semiBold,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.lightAccentGlow,
  );

  static const otpResendingBtn = TextStyle(
    color: AppColors.textSecondary,
    fontSize: AppFontSizes.bodySmall,
    fontWeight: AppFontWeights.semiBold,
    decoration: TextDecoration.none,
  );

  static final otpFooter = TextStyle(
    color: AppColors.textSecondary.withOpacity(0.6),
    fontSize: AppFontSizes.captionLarge,
    fontWeight: AppFontWeights.normal,
  );

  // Complete Profile Screen
  static const completeProfileTitle = TextStyle(
    fontSize: AppFontSizes.headlineLarge,
    fontWeight: AppFontWeights.bold,
    color: AppColors.white,
    letterSpacing: -0.5,
  );

  static const completeProfileSub = TextStyle(
    fontSize: AppFontSizes.body,
    color: AppColors.textSecondary,
    height: 1.55,
  );

  static const completeProfileFieldDesc = TextStyle(
    fontSize: AppFontSizes.captionLarge,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const completeProfileInput = TextStyle(
    color: AppColors.textPrimary,
    fontSize: AppFontSizes.bodyMedium,
    fontWeight: AppFontWeights.normal,
  );

  static const completeProfileButton = TextStyle(
    color: AppColors.textPrimary,
    fontSize: AppFontSizes.bodyLarge,
    fontWeight: AppFontWeights.semiBold,
    letterSpacing: 0.2,
  );

  static const completeProfileFooter = TextStyle(
    fontSize: AppFontSizes.captionLarge,
    color: AppColors.textMuted,
    height: 1.5,
  );

  // Splash Screen
  static const splashTitle = TextStyle(
    fontSize: AppFontSizes.displayMedium,
    fontWeight: AppFontWeights.bold,
    color: AppColors.white,
    letterSpacing: 3.5,
    shadows: [
      Shadow(
        color: AppColors.welcomePurple,
        blurRadius: 15,
      ),
    ],
  );

  static final splashTagline = TextStyle(
    color: AppColors.white.withOpacity(0.7),
    fontSize: AppFontSizes.body,
    fontWeight: AppFontWeights.normal,
    letterSpacing: 1.2,
  );

  static const splashLoading = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.bodyMedium,
    fontWeight: AppFontWeights.medium,
  );

  // Home Screen
  static const homeLoading = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.bodyMedium,
    fontWeight: AppFontWeights.medium,
  );

  static const homeInitialText = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.displayXLarge,
    fontWeight: AppFontWeights.bold,
  );

  static const homeHeaderTitle = TextStyle(
    fontSize: AppFontSizes.displayMedium,
    fontWeight: AppFontWeights.bold,
    color: AppColors.white,
    letterSpacing: -0.5,
  );

  static final homeHeaderEmail = TextStyle(
    color: AppColors.white.withOpacity(0.38),
    fontSize: AppFontSizes.body,
    fontWeight: AppFontWeights.normal,
    letterSpacing: 0.2,
  );

  static const homeDashboardTitle = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.titleSmall,
    fontWeight: AppFontWeights.semiBold,
  );

  static final homeDashboardDesc = TextStyle(
    color: AppColors.white.withOpacity(0.7),
    fontSize: AppFontSizes.body,
    height: 1.55,
    fontWeight: AppFontWeights.normal,
  );

  static const homeDashboardSync = TextStyle(
    color: AppColors.greenAccent,
    fontSize: AppFontSizes.bodySmall,
    fontWeight: AppFontWeights.medium,
  );

  // Thoughts Page
  static const thoughtsTitle = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.displayMedium,
    fontWeight: AppFontWeights.bold,
    letterSpacing: -0.5,
  );

  static final thoughtsSub = TextStyle(
    color: AppColors.white.withOpacity(0.5),
    fontSize: AppFontSizes.bodyMedium,
  );

  static final thoughtsSearchHint = TextStyle(
    color: AppColors.white.withOpacity(0.3),
    fontSize: AppFontSizes.bodyMedium,
  );

  static const thoughtsEmptyTitle = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.bodyLarge,
    fontWeight: AppFontWeights.semiBold,
  );

  static const thoughtsCardTitle = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.titleSmall,
    fontWeight: AppFontWeights.bold,
  );

  static final thoughtsCardContent = TextStyle(
    color: AppColors.white.withOpacity(0.65),
    fontSize: AppFontSizes.body,
    height: 1.45,
  );

  static final thoughtsCardTime = TextStyle(
    color: AppColors.white.withOpacity(0.35),
    fontSize: AppFontSizes.captionLarge,
  );

  static const thoughtsSheetTitle = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.titleLarge,
    fontWeight: AppFontWeights.bold,
    letterSpacing: -0.5,
  );

  static const thoughtsSheetInput = TextStyle(color: AppColors.white);
  static final thoughtsSheetInputHint = TextStyle(color: AppColors.white.withOpacity(0.3));

  static const thoughtsSheetSubmit = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.bodyLarge,
    fontWeight: AppFontWeights.bold,
  );

  // AI Coach Page
  static const coachHeaderTitle = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.titleSmall,
    fontWeight: AppFontWeights.bold,
    letterSpacing: -0.2,
  );

  static final coachHeaderSub = TextStyle(
    color: AppColors.greenAccent.withOpacity(0.85),
    fontSize: AppFontSizes.captionLarge,
    fontWeight: AppFontWeights.bold,
  );

  static const coachMessageText = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.bodyMedium,
    height: 1.45,
  );

  static final coachMessageTimeCoach = TextStyle(
    color: AppColors.white.withOpacity(0.3),
    fontSize: AppFontSizes.captionMini,
  );

  static final coachMessageTimeUser = TextStyle(
    color: AppColors.white.withOpacity(0.7),
    fontSize: AppFontSizes.captionMini,
  );

  static const coachChipLabel = TextStyle(
    color: AppColors.lightAccentGlow,
    fontSize: AppFontSizes.bodySmall,
    fontWeight: AppFontWeights.bold,
  );

  static const coachInputText = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.bodyMedium,
  );

  static final coachInputHint = TextStyle(
    color: AppColors.white.withOpacity(0.3),
    fontSize: AppFontSizes.bodyMedium,
  );

  // Insight Page
  static const insightTitle = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.displayMedium,
    fontWeight: AppFontWeights.bold,
    letterSpacing: -0.5,
  );

  static final insightSub = TextStyle(
    color: AppColors.white.withOpacity(0.5),
    fontSize: AppFontSizes.bodyMedium,
  );

  static const insightSectionTitle = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.titleMedium,
    fontWeight: AppFontWeights.bold,
    letterSpacing: -0.2,
  );

  static const insightAdviceTitle = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.bodyMedium,
    fontWeight: AppFontWeights.bold,
  );

  static final insightAdviceDesc = TextStyle(
    color: AppColors.white.withOpacity(0.65),
    fontSize: AppFontSizes.bodySmall,
    height: 1.45,
  );

  static final insightMetricTitle = TextStyle(
    color: AppColors.white.withOpacity(0.38),
    fontSize: AppFontSizes.bodySmall,
    fontWeight: AppFontWeights.bold,
  );

  static const insightMetricValue = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.titleLarge,
    fontWeight: AppFontWeights.bold,
  );

  static final insightMetricSub = TextStyle(
    color: AppColors.white.withOpacity(0.4),
    fontSize: AppFontSizes.captionLarge,
  );

  static const insightClarityVal = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.titleLarge,
    fontWeight: AppFontWeights.bold,
  );

  static final insightClarityLabel = TextStyle(
    color: AppColors.white.withOpacity(0.38),
    fontSize: AppFontSizes.captionMini,
    fontWeight: AppFontWeights.medium,
  );

  static const insightClarityCardTitle = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.titleSmall,
    fontWeight: AppFontWeights.bold,
  );

  static final insightClarityCardDesc = TextStyle(
    color: AppColors.white.withOpacity(0.7),
    fontSize: AppFontSizes.bodySmall,
    height: 1.45,
  );

  static const insightFocusTitle = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.titleSmall,
    fontWeight: AppFontWeights.bold,
  );

  static final insightFocusSub = TextStyle(
    color: AppColors.white.withOpacity(0.38),
    fontSize: AppFontSizes.captionLarge,
  );

  static const insightFocusPercent = TextStyle(
    color: AppColors.secondaryAccent,
    fontSize: AppFontSizes.captionLarge,
    fontWeight: AppFontWeights.bold,
  );

  // Profile Page
  static const profileSectionTitle = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.titleSmall,
    fontWeight: AppFontWeights.bold,
    letterSpacing: -0.2,
  );

  static const profileUsername = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.headlineSmall,
    fontWeight: AppFontWeights.bold,
  );

  static final profileEmail = TextStyle(
    color: AppColors.white.withOpacity(0.4),
    fontSize: AppFontSizes.body,
  );

  static const profileStatVal = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.titleSmall,
    fontWeight: AppFontWeights.bold,
  );

  static final profileStatLabel = TextStyle(
    color: AppColors.white.withOpacity(0.35),
    fontSize: AppFontSizes.captionLarge,
  );

  static const profileTileTitle = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSizes.bodyMedium,
    fontWeight: AppFontWeights.semiBold,
  );

  static final profileTileSub = TextStyle(
    color: AppColors.white.withOpacity(0.4),
    fontSize: AppFontSizes.captionLarge,
  );

  static const profileTileActive = TextStyle(
    color: AppColors.greenAccent,
    fontSize: AppFontSizes.captionLarge,
    fontWeight: AppFontWeights.bold,
  );

  static const profileLogoutText = TextStyle(
    color: AppColors.redAccent,
    fontSize: AppFontSizes.bodyLarge,
    fontWeight: AppFontWeights.bold,
  );
}
