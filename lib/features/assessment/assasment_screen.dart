// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/features/assessment/repository/assasment_repository.dart';
import 'package:mainsupabase_projuct/features/dashboard/home_screen.dart';
import 'package:mainsupabase_projuct/features/assessment/models/mental_stage.dart';
import 'package:mainsupabase_projuct/features/assessment/service/assasment_scoring.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_radius.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/cyber_grid_painter.dart';
import '../../shared/widgets/glowing_orb.dart';
import 'provider/assasment_provider.dart' as assasment_questions;

class AssasmentScreen extends StatefulWidget {
  const AssasmentScreen({super.key});

  @override
  State<AssasmentScreen> createState() => _AssasmentScreenState();
}

class _AssasmentScreenState extends State<AssasmentScreen> with TickerProviderStateMixin {
  late final AnimationController _orbController;
  late final AnimationController _cardTransitionController;
  late final Animation<double> _cardFadeAnim;
  late final Animation<Offset> _cardSlideAnim;

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _cardTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _cardFadeAnim = CurvedAnimation(
      parent: _cardTransitionController,
      curve: Curves.easeIn,
    );

    _cardSlideAnim = Tween<Offset>(
      begin: const Offset(0.04, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardTransitionController,
      curve: Curves.easeOutCubic,
    ));

    _cardTransitionController.forward();
  }

  @override
  void dispose() {
    _orbController.dispose();
    _cardTransitionController.dispose();
    super.dispose();
  }

  void _triggerQuestionTransition() {
    _cardTransitionController.reset();
    _cardTransitionController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<assasment_questions.AssessmentProvider>();
    final currentQuestion = provider.currentQuestion;
    final totalQuestions = provider.questions.length;
    final currentNumber = provider.currentIndex + 1;
    final hasAnswered = provider.answers.containsKey(currentQuestion.id);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Cyber Space Glowing Background
          AnimatedBuilder(
            animation: _orbController,
            builder: (context, _) {
              final t = _orbController.value;
              return Stack(
                children: [
                  Positioned(
                    top: -80 + (t * 30),
                    left: -60 + (t * 15),
                    child: const GlowingOrb(
                      size: 340,
                      color: AppColors.primaryAccent,
                      opacity: 0.15,
                    ),
                  ),
                  Positioned(
                    bottom: -100 + (t * 40),
                    right: -80 + (t * 20),
                    child: const GlowingOrb(
                      size: 380,
                      color: AppColors.secondaryAccent,
                      opacity: 0.12,
                    ),
                  ),
                ],
              );
            },
          ),

          // Cyber Grid Visual Overlay
          CustomPaint(
            painter: CyberGridPainter(color: AppColors.white.withOpacity(0.02)),
            child: const SizedBox.expand(),
          ),

          // Main Responsive Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header / Navigation Bar
                _buildHeader(context, provider),

                // Question and Options (Scrollable & Responsive)
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.xxxl,
                      vertical: AppSizes.lg,
                    ),
                    child: SlideTransition(
                      position: _cardSlideAnim,
                      child: FadeTransition(
                        opacity: _cardFadeAnim,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Progress indicator section
                            _buildProgressSection(currentNumber, totalQuestions, provider.progress),
                            const SizedBox(height: AppSizes.huge),

                            // Question Title
                            _buildQuestionText(currentQuestion.question),
                            const SizedBox(height: AppSizes.giant),

                            // Answer Options List
                            ...currentQuestion.options.map((option) {
                              final isSelected = provider.isSelected(option.score);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppSizes.md),
                                child: _buildOptionTile(option, isSelected, provider),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom Control Action Row
                _buildBottomControls(context, provider, hasAnswered),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, assasment_questions.AssessmentProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.xl,
        vertical: AppSizes.md,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(AppIcons.close, color: AppColors.white),
            onPressed: () {
              // Custom reset dialog if progress is made, or simple pop
              if (provider.answers.isNotEmpty) {
                _showExitConfirmationDialog(context, provider);
              } else {
                Navigator.maybePop(context);
              }
            },
          ),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.textPrimary, AppColors.lightAccentGlow],
            ).createShader(bounds),
            child: const Text(
              'CEREBRAL ASSESSMENT',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: AppFontSizes.bodyLarge,
                fontWeight: AppFontWeights.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          // Empty placeholder to balance header
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildProgressSection(int currentNumber, int totalQuestions, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question $currentNumber of $totalQuestions',
              style: TextStyle(
                color: AppColors.white.withOpacity(0.5),
                fontSize: AppFontSizes.bodySmall,
                fontWeight: AppFontWeights.medium,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}% Complete',
              style: const TextStyle(
                color: AppColors.lightAccentGlow,
                fontSize: AppFontSizes.bodySmall,
                fontWeight: AppFontWeights.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        ClipRRect(
          borderRadius: AppRadius.r8,
          child: SizedBox(
            height: 8,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.progressBackground,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionText(String questionText) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.xxl),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.02),
        borderRadius: AppRadius.r24,
        border: Border.all(color: AppColors.white.withOpacity(0.04)),
      ),
      child: Text(
        questionText,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: AppFontWeights.semiBold,
          height: 1.45,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildOptionTile(
    dynamic option,
    bool isSelected,
    assasment_questions.AssessmentProvider provider,
  ) {
    return GestureDetector(
      onTap: () {
        provider.selectAnswer(option.score);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.xxl,
          vertical: AppSizes.xl,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryAccent.withOpacity(0.12)
              : AppColors.white.withOpacity(0.04),
          borderRadius: AppRadius.r20,
          border: Border.all(
            color: isSelected
                ? AppColors.lightAccentGlow
                : AppColors.white.withOpacity(0.06),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryAccent.withOpacity(0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Custom cyber radio button indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.lightAccentGlow
                      : AppColors.white.withOpacity(0.3),
                  width: isSelected ? 6.5 : 2.0,
                ),
                color: isSelected ? AppColors.white : AppColors.transparent,
              ),
            ),
            const SizedBox(width: AppSizes.lg),
            Expanded(
              child: Text(
                option.text,
                style: TextStyle(
                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                  fontSize: AppFontSizes.bodyLarge,
                  fontWeight: isSelected ? AppFontWeights.bold : AppFontWeights.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls(
    BuildContext context,
    assasment_questions.AssessmentProvider provider,
    bool hasAnswered,
  ) {
    final hasNext = provider.hasNext;

    return Container(
      padding: const EdgeInsets.all(AppSizes.xxxl),
      decoration: const BoxDecoration(
        color: AppColors.backgroundDark,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Previous Question Button
          Expanded(
            child: _buildNavigationButton(
              label: 'Previous',
              icon: Icons.arrow_back_rounded,
              isEnabled: provider.hasPrevious,
              onPressed: () {
                provider.previousQuestion();
                _triggerQuestionTransition();
              },
              isPrimary: false,
            ),
          ),
          const SizedBox(width: AppSizes.lg),

          // Next / Finish Assessment Button
          Expanded(
            child: _buildNavigationButton(
              label: hasNext ? 'Next' : 'Finish Assessment',
              icon: hasNext ? Icons.arrow_forward_rounded : Icons.check_circle_outline_rounded,
              isEnabled: hasAnswered,
             onPressed: () async {
  if (hasNext) {
    provider.nextQuestion();
    _triggerQuestionTransition();
    return;
  }

  try {
    final scoringService = AssessmentScoringService();
    final repository = AssasmentRepository();

    final result = scoringService.calculate(
      questions: provider.questions,
      answers: provider.answers,
    );

    await repository.saveAssessment(
      result: result,
      answers: provider.answers,
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Assessment Completed! '
          'Clarity: ${result.overallClarity.round()}% | '
          'Stage: ${result.stage.title}',
        ),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  } catch (e) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Failed to save assessment.\n${e.toString()}',
        ),
      ),
    );
  }
},
              isPrimary: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required String label,
    required IconData icon,
    required bool isEnabled,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    final Color buttonColor = isPrimary
        ? (isEnabled ? AppColors.primaryAccent : AppColors.primaryAccent.withOpacity(0.2))
        : AppColors.transparent;

    final Color textColor = isPrimary
        ? (isEnabled ? AppColors.textPrimary : AppColors.textPrimary.withOpacity(0.4))
        : (isEnabled ? AppColors.textPrimary : AppColors.textPrimary.withOpacity(0.25));

    final Border? border = isPrimary
        ? null
        : Border.all(
            color: isEnabled ? AppColors.white.withOpacity(0.2) : AppColors.white.withOpacity(0.08),
            width: 1.0,
          );

    return InkWell(
      onTap: isEnabled ? onPressed : null,
      borderRadius: AppRadius.r18,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: AppRadius.r18,
          border: border,
          boxShadow: (isPrimary && isEnabled)
              ? [
                  BoxShadow(
                    color: AppColors.primaryAccent.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isPrimary) ...[
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: AppSizes.sm),
            ],
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: AppFontSizes.bodyLarge,
                fontWeight: AppFontWeights.semiBold,
                letterSpacing: 0.2,
              ),
            ),
            if (isPrimary) ...[
              const SizedBox(width: AppSizes.sm),
              Icon(icon, color: textColor, size: 20),
            ],
          ],
        ),
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context, assasment_questions.AssessmentProvider provider) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.6),
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.r24,
            side: const BorderSide(color: AppColors.border, width: 1.5),
          ),
          title: const Text(
            'Discard Assessment?',
            style: AppTextStyles.dialogTitle,
          ),
          content: Text(
            'Your progress will be lost. Are you sure you want to exit?',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppFontSizes.bodyMedium,
              height: 1.4,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.xxxl,
            vertical: AppSizes.xl,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppFontSizes.bodyLarge,
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                provider.reset();
                Navigator.pop(context); // Close dialog
                Navigator.maybePop(context); // Close screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.redAccent.withOpacity(0.12),
                foregroundColor: AppColors.redAccent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.r12,
                  side: BorderSide(color: AppColors.redAccent.withOpacity(0.3), width: 1),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.lg,
                  vertical: AppSizes.md,
                ),
              ),
              child: const Text(
                'Exit',
                style: TextStyle(
                  fontWeight: AppFontWeights.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}