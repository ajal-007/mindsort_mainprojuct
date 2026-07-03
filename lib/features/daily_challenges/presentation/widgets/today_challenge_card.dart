import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';

class TodayChallengeCard extends StatefulWidget {
  final String title;
  final String description;
  final String rewardXp;
  final VoidCallback? onStart;

  const TodayChallengeCard({
    super.key,
    required this.title,
    required this.description,
    required this.rewardXp,
    this.onStart,
  });

  @override
  State<TodayChallengeCard> createState() => _TodayChallengeCardState();
}

class _TodayChallengeCardState extends State<TodayChallengeCard> {
  bool _isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.r28,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.xxl),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.02),
            borderRadius: AppRadius.r28,
            border: Border.all(
              color: AppColors.challengePurple.withOpacity(0.15),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.challengePurple.withOpacity(0.02),
                blurRadius: 25,
                spreadRadius: -5,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: Glowing Brain Icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.r16,
                      gradient: const LinearGradient(
                        colors: [AppColors.challengePurple, AppColors.challengeBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.challengePurple.withOpacity(0.35),
                          blurRadius: 12,
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppColors.white, AppColors.electricCyan],
                      ).createShader(bounds),
                      child: const Icon(
                        Icons.psychology_rounded,
                        color: AppColors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.lg),

                  // Center: Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Today's Challenge",
                          style: TextStyle(
                            color: AppColors.challengePurple,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          widget.description,
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.4),
                            fontSize: 11,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),

                  // Right: XP Label
                  Text(
                    widget.rewardXp,
                    style: const TextStyle(
                      color: AppColors.electricCyan,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xxl),

              // Bottom Right: Start Challenge Button
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTapDown: (_) => setState(() => _isButtonPressed = true),
                  onTapCancel: () => setState(() => _isButtonPressed = false),
                  onTapUp: (_) {
                    setState(() => _isButtonPressed = false);
                    widget.onStart?.call();
                  },
                  child: AnimatedScale(
                    scale: _isButtonPressed ? 0.95 : 1.0,
                    duration: const Duration(milliseconds: 100),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.xxxl,
                        vertical: AppSizes.md,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.r16,
                        gradient: const LinearGradient(
                          colors: [AppColors.challengePurple, AppColors.challengeBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.challengePurple.withOpacity(0.35),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: const Text(
                        'Start Challenge',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
