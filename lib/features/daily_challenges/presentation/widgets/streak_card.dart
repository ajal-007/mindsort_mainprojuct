import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';

class StreakCard extends StatelessWidget {
  final int streakDays;

  const StreakCard({
    super.key,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.r20,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.xxl,
            vertical: AppSizes.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.03),
            borderRadius: AppRadius.r20,
            border: Border.all(
              color: AppColors.white.withOpacity(0.08),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.orangeAccent.withOpacity(0.03),
                blurRadius: 15,
                spreadRadius: -2,
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.orange, Colors.redAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: Icon(
                  Icons.local_fire_department_rounded,
                  color: AppColors.white,
                  size: 28,
                  shadows: [
                    Shadow(
                      color: Colors.redAccent.withOpacity(0.6),
                      blurRadius: 12,
                    )
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$streakDays',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Day Streak',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
