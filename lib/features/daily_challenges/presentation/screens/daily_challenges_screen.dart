import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/widgets/glowing_orb.dart';
import '../../models/challenge_node_model.dart';
import '../../providers/challenge_provider.dart';
import '../widgets/challenge_header.dart';
import '../widgets/challenge_map.dart';
import '../widgets/progress_card.dart';
import '../widgets/today_challenge_card.dart';

class DailyChallengesScreen extends StatelessWidget {
  const DailyChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final challengeProvider = context.watch<ChallengeProvider>();
    final challenges = challengeProvider.challenges;
    final int activeDayIndex = challenges.indexWhere(
      (node) => node.status == ChallengeStatus.today,
    );
    final todayChallenge = challengeProvider.todayChallenge;

    return Scaffold(
      backgroundColor: AppColors.challengesBackground,
      body: Stack(
        children: [
          // Background neon glowing orbs to match MindSort cyber visuals
          Positioned(
            top: 220,
            left: -80,
            child: GlowingOrb(
              size: 320,
              color: AppColors.challengePurple,
              opacity: 0.12,
            ),
          ),
          Positioned(
            bottom: 300,
            right: -100,
            child: GlowingOrb(
              size: 380,
              color: AppColors.electricCyan,
              opacity: 0.08,
            ),
          ),

          // Scrollable layout structure
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. Navigation & Info Header
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.xxxl,
                    vertical: AppSizes.lg,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: ChallengeHeader(
                      streakDays: challengeProvider.currentStreak,
                      onBackTap: () {
                        // TODO: Navigate back
                        Navigator.maybePop(context);
                      },
                    ),
                  ),
                ),

                // 2. Main Completion Progress Card
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxxl),
                  sliver: SliverToBoxAdapter(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 600),
                      builder: (context, val, child) {
                        return Opacity(
                          opacity: val,
                          child: Transform.translate(
                            offset: Offset(0, 15 * (1 - val)),
                            child: child,
                          ),
                        );
                      },
                      child: ProgressCard(
                        completedDays: challengeProvider.completedDays,
                        totalDays: challengeProvider.totalDays,
                        nextRewardDay: challengeProvider.nextRewardDay,
                      ),
                    ),
                  ),
                ),

                // 3. Curved snaking journey map
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSizes.xl),
                    child: ChallengeMap(
                      nodes: challenges,
                      activeDayIndex: activeDayIndex,
                      onNodeTap: (node) {
                        // TODO:
                        // Navigate to ChallengeDetailScreen
                      },
                    ),
                  ),
                ),

                // 4. Sticky today active challenge details card
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.xxxl,
                    vertical: AppSizes.xl,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, val, child) {
                        return Opacity(
                          opacity: val,
                          child: Transform.translate(
                            offset: Offset(0, 10 * (1 - val)),
                            child: child,
                          ),
                        );
                      },
                      child: TodayChallengeCard(
                        title: todayChallenge.title,
                        description: todayChallenge.description,
                        rewardXp: todayChallenge.reward,
                        onStart: () {
                          // TODO:
                          // Navigate to ChallengeDetailScreen and initiate challenge
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
