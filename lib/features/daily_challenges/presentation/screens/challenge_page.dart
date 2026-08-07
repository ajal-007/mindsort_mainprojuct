import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../dashboard/models/dashboardata.dart';
import '../../../dashboard/provider/dashboard_provider.dart';
import '../../models/challenge_difficulty.dart';
import '../../models/challenge_model.dart';
import '../../providers/challenge_provider.dart';

class ChallengePage extends StatefulWidget {
  final int day;

  const ChallengePage({
    super.key,
    required this.day,
  });

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadChallenges();
    });
  }

  void _loadChallenges() {
    final dashboardProvider = context.read<DashboardProvider>();
    final challengeProvider = context.read<ChallengeProvider>();

    if (dashboardProvider.dashboard != null) {
      challengeProvider.loadChallengesForDay(
        day: widget.day,
        dashboard: dashboardProvider.dashboard!,
      );
    } else {
      dashboardProvider.loadDashboard().then((_) {
        if (dashboardProvider.dashboard != null && mounted) {
          context.read<ChallengeProvider>().loadChallengesForDay(
                day: widget.day,
                dashboard: dashboardProvider.dashboard!,
              );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardProvider>();
    final challengeProvider = context.watch<ChallengeProvider>();

    final dashboard = dashboardProvider.dashboard;

    if (dashboard == null) {
      if (dashboardProvider.isLoading) {
        return const Scaffold(
          backgroundColor: AppColors.backgroundDark,
          body: Center(
            child: CircularProgressIndicator(color: AppColors.primaryAccent),
          ),
        );
      } else if (dashboardProvider.error != null) {
        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          body: _buildErrorState(context, dashboardProvider.error!, null),
        );
      } else {
        return const Scaffold(
          backgroundColor: AppColors.backgroundDark,
          body: Center(
            child: CircularProgressIndicator(color: AppColors.primaryAccent),
          ),
        );
      }
    }

    if (challengeProvider.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: _buildLoadingState(),
      );
    }

    if (challengeProvider.error != null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: _buildErrorState(context, challengeProvider.error!, dashboard),
      );
    }

    final challenges = challengeProvider.challengesForSelectedDay;

    if (challenges.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: _buildLoadingState(),
      );
    }

    final currentDayProgress = challengeProvider.currentDay;
    final difficulty = challenges.first.difficulty;
    final completedCount = challenges.where((c) => c.completed).toList().length;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(widget.day, difficulty),
                  const SizedBox(height: AppSizes.xl),
                  _buildProgressCard(widget.day, completedCount, challenges.length),
                  const SizedBox(height: AppSizes.md),
                  _buildFutureEnhancementsRow(),
                  const SizedBox(height: AppSizes.xl),
                  const Text(
                    "Today's Challenges",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  ...List.generate(
                    challenges.length,
                    (index) => _buildChallengeCard(
                      context,
                      challenges[index],
                      challengeProvider,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomButton(context, challenges, challengeProvider, currentDayProgress, dashboard),
        ],
      ),
    );
  }

  Widget _buildHeader(int day, ChallengeDifficulty difficulty) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Daily Challenges",
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              "Day $day Workspace",
              style: TextStyle(
                color: AppColors.white.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
        _buildDifficultyBadge(difficulty),
      ],
    );
  }

  Widget _buildDifficultyBadge(ChallengeDifficulty difficulty) {
    Color badgeColor;
    switch (difficulty) {
      case ChallengeDifficulty.veryEasy:
        badgeColor = AppColors.electricCyan;
        break;
      case ChallengeDifficulty.easy:
        badgeColor = AppColors.secondaryAccent;
        break;
      case ChallengeDifficulty.medium:
        badgeColor = AppColors.primaryAccent;
        break;
      case ChallengeDifficulty.hard:
        badgeColor = AppColors.challengePurple;
        break;
      case ChallengeDifficulty.expert:
        badgeColor = AppColors.orangeAccent;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: AppRadius.r12,
        border: Border.all(
          color: badgeColor.withOpacity(0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(
            difficulty.stars,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 2.0),
              child: Icon(
                Icons.star_rounded,
                color: badgeColor,
                size: 13,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.xs),
          Text(
            difficulty.title,
            style: TextStyle(
              color: badgeColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(int day, int completedCount, int totalCount) {
    final double percent = totalCount > 0 ? completedCount / totalCount : 0.0;
    return Container(
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.04),
        borderRadius: AppRadius.r20,
        border: Border.all(
          color: AppColors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Day $day Status",
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$completedCount / $totalCount Completed",
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          _buildProgressBar(percent),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double percent) {
    return Container(
      height: 8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(4),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOutCubic,
                width: maxWidth * percent,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryAccent, AppColors.electricCyan],
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryAccent.withOpacity(0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFutureEnhancementsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildEnhancementBadge(
            icon: Icons.local_fire_department_rounded,
            label: "5-Day Streak",
            color: AppColors.orangeAccent,
          ),
          const SizedBox(width: AppSizes.md),
          _buildEnhancementBadge(
            icon: Icons.card_giftcard_rounded,
            label: "Daily Reward",
            color: AppColors.electricCyan,
          ),
          const SizedBox(width: AppSizes.md),
          _buildEnhancementBadge(
            icon: Icons.insights_rounded,
            label: "Clarity Score +10",
            color: AppColors.secondaryAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancementBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: AppRadius.r12,
        border: Border.all(
          color: color.withOpacity(0.15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: AppSizes.xs),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.85),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(
    BuildContext context,
    Challenge challenge,
    ChallengeProvider provider,
  ) {
    final bool isCompleted = challenge.completed;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.white.withOpacity(0.015)
            : AppColors.white.withOpacity(0.04),
        borderRadius: AppRadius.r20,
        border: Border.all(
          color: isCompleted
              ? AppColors.primaryAccent.withOpacity(0.15)
              : AppColors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.xs),
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.primaryAccent.withOpacity(0.1)
                  : AppColors.white.withOpacity(0.06),
              borderRadius: AppRadius.r8,
            ),
            child: Text(
              "0${challenge.challengeNumber}",
              style: TextStyle(
                color: isCompleted ? AppColors.primaryAccent : AppColors.white.withOpacity(0.7),
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Space Grotesk',
              ),
            ),
          ),
          const SizedBox(width: AppSizes.lg),
          Expanded(
            child: Opacity(
              opacity: isCompleted ? 0.55 : 1.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge.title,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.1,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    challenge.description,
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.55),
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: AppColors.white.withOpacity(0.4),
                            size: 14,
                          ),
                          const SizedBox(width: AppSizes.xs),
                          Text(
                            "${challenge.estimatedMinutes} min",
                            style: TextStyle(
                              color: AppColors.white.withOpacity(0.4),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      _buildAIExplanationButton(context, challenge),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSizes.md),
          _buildCheckbox(context, challenge, provider),
        ],
      ),
    );
  }

  Widget _buildCheckbox(
    BuildContext context,
    Challenge challenge,
    ChallengeProvider provider,
  ) {
    final bool isCompleted = challenge.completed;
    final bool isPastDay = challenge.day < provider.currentDay;

    return GestureDetector(
      onTap: (isCompleted || isPastDay)
          ? null
          : () {
              provider.toggleChallenge(challenge);
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.bounceOut,
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.primaryAccent : AppColors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isCompleted ? AppColors.primaryAccent : AppColors.white.withOpacity(0.25),
            width: 1.5,
          ),
          boxShadow: isCompleted
              ? [
                  BoxShadow(
                    color: AppColors.primaryAccent.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 0),
                  )
                ]
              : null,
        ),
        child: isCompleted
            ? const Icon(
                Icons.check_rounded,
                color: AppColors.white,
                size: 16,
              )
            : null,
      ),
    );
  }

  Widget _buildAIExplanationButton(BuildContext context, Challenge challenge) {
    return InkWell(
      onTap: () {
        _showAIExplanationDialog(context, challenge);
      },
      borderRadius: AppRadius.r8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: AppSizes.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.electricCyan,
              size: 13,
            ),
            const SizedBox(width: AppSizes.xs),
            Text(
              "AI Explanation",
              style: TextStyle(
                color: AppColors.electricCyan.withOpacity(0.9),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAIExplanationDialog(BuildContext context, Challenge challenge) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSheet,
      barrierColor: AppColors.black.withOpacity(0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.top30,
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppSizes.xxl),
          decoration: const BoxDecoration(
            color: AppColors.backgroundSheet,
            borderRadius: AppRadius.top30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.electricCyan,
                    size: 20,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  const Text(
                    "AI Coach Recommendation",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              Text(
                "Why: \"${challenge.title}\"",
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                "MindSort's cognitive neural analysis selected this challenge specifically for Day ${challenge.day}. It directly addresses mental fatigue, enhances focus resilience, and fits within your current estimated stress profile to foster cerebral clarity.",
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.65),
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSizes.xl),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.electricCyan,
                  ),
                  child: const Text(
                    "Acknowledge Guide",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomButton(
    BuildContext context,
    List<Challenge> challenges,
    ChallengeProvider provider,
    int currentDayProgress,
    DashboardData dashboard,
  ) {
    final bool isPastDay = widget.day < currentDayProgress;
    final bool allCompleted = challenges.isNotEmpty && challenges.every((c) => c.completed);

    if (isPastDay) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl, vertical: AppSizes.lg),
        decoration: BoxDecoration(
          color: AppColors.backgroundDark,
          border: Border(
            top: BorderSide(
              color: AppColors.white.withOpacity(0.06),
              width: 1,
            ),
          ),
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surfaceDark,
            padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.r16,
              side: BorderSide(
                color: AppColors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: const Text(
            "Return to Journey",
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      );
    }

    final int nextDay = widget.day + 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl, vertical: AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        border: Border(
          top: BorderSide(
            color: AppColors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
      ),
      child: ElevatedButton(
        onPressed: allCompleted
    ? () {
        Navigator.pop(context);
      }
    : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryAccent,
          disabledBackgroundColor: AppColors.white.withOpacity(0.04),
          padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.r16,
            side: BorderSide(
              color: allCompleted ? AppColors.primaryAccent.withOpacity(0.35) : AppColors.transparent,
              width: 1,
            ),
          ),
          elevation: allCompleted ? 8 : 0,
          shadowColor: AppColors.primaryAccent.withOpacity(0.4),
        ),
        child: Text(
          allCompleted ? "Complete Today's Journey": "Complete remaining challenges",
          style: TextStyle(
            color: allCompleted ? AppColors.white : AppColors.white.withOpacity(0.25),
            fontWeight: FontWeight.bold,
            fontSize: 15,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryAccent,
            strokeWidth: 3,
          ),
          SizedBox(height: AppSizes.lg),
          Text(
            "Syncing Daily Objectives...",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error, DashboardData? dashboard) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.orangeAccent,
              size: 44,
            ),
            const SizedBox(height: AppSizes.lg),
            const Text(
              "Sync Interrupted",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              error.replaceFirst("Exception: ", ""),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: AppSizes.xxl),
            if (dashboard != null)
              ElevatedButton.icon(
                onPressed: () {
                  _loadChallenges();
                },
                icon: const Icon(Icons.refresh_rounded, color: AppColors.white, size: 18),
                label: const Text("Retry Connection"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent.withOpacity(0.12),
                  foregroundColor: AppColors.primaryAccent,
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxl, vertical: AppSizes.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.r12,
                    side: BorderSide(
                      color: AppColors.primaryAccent.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
