import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import 'streak_card.dart';

class ChallengeHeader extends StatelessWidget {
  final int streakDays;
  final VoidCallback? onBackTap;

  const ChallengeHeader({
    super.key,
    required this.streakDays,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: Back button (glowing glass square)
        GestureDetector(
          onTap: onBackTap ?? () => Navigator.maybePop(context),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.03),
              borderRadius: AppRadius.r12,
              border: Border.all(
                color: AppColors.electricCyan.withOpacity(0.25),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.electricCyan.withOpacity(0.04),
                  blurRadius: 10,
                )
              ],
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.white,
              size: 20,
            ),
          ),
        ),

        // Center: Title Block
        const Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Challenges',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Build your mind, one day at a time.',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Right: Day Streak Card
        StreakCard(streakDays: streakDays),
      ],
    );
  }
}
