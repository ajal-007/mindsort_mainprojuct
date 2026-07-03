import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';

class ProgressCard extends StatelessWidget {
  final int completedDays;
  final int totalDays;
  final int nextRewardDay;

  const ProgressCard({
    super.key,
    required this.completedDays,
    required this.totalDays,
    required this.nextRewardDay,
  });

  @override
  Widget build(BuildContext context) {
    final double nextRewardProgress = completedDays / nextRewardDay;

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
              color: AppColors.electricCyan.withOpacity(0.15),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.electricCyan.withOpacity(0.02),
                blurRadius: 25,
                spreadRadius: -5,
              )
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 360;

              return isSmallScreen
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildCircularProgressSection(),
                        const SizedBox(height: AppSizes.xl),
                        _buildNextRewardSection(nextRewardProgress),
                        const SizedBox(height: AppSizes.xl),
                        _buildMilestoneSection(),
                      ],
                    )
                  : Row(
                      children: [
                        // Left Section: Circular progress
                        Expanded(
                          flex: 11,
                          child: _buildCircularProgressSection(),
                        ),
                        
                        // Vertical Divider
                        Container(
                          height: 50,
                          width: 1,
                          color: AppColors.white.withOpacity(0.06),
                          margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                        ),

                        // Middle Section: Next Reward progress
                        Expanded(
                          flex: 12,
                          child: _buildNextRewardSection(nextRewardProgress),
                        ),

                        // Vertical Divider
                        Container(
                          height: 50,
                          width: 1,
                          color: AppColors.white.withOpacity(0.06),
                          margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                        ),

                        // Right Section: Milestone
                        Expanded(
                          flex: 10,
                          child: _buildMilestoneSection(),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCircularProgressSection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: CustomPaint(
            painter: _CircularProgressPainter(
              progress: completedDays / totalDays,
              trackColor: AppColors.white.withOpacity(0.04),
              activeColors: const [AppColors.challengeBlue, AppColors.electricCyan],
            ),
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$completedDays/$totalDays',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Days Completed',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNextRewardSection(double nextRewardProgress) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Next Reward',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Complete Day $nextRewardDay',
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        // Progress Slider
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            height: 6,
            width: double.infinity,
            color: AppColors.white.withOpacity(0.05),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: nextRewardProgress.clamp(0.0, 1.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.challengePurple, AppColors.challengeBlue],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMilestoneSection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.challengePurple.withOpacity(0.12),
            borderRadius: AppRadius.r12,
            border: Border.all(
              color: AppColors.challengePurple.withOpacity(0.25),
            ),
          ),
          alignment: Alignment.center,
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.challengePurple, AppColors.electricCyan],
            ).createShader(bounds),
            child: const Icon(
              Icons.card_giftcard_rounded,
              color: AppColors.white,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Milestone',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Day 30',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.workspace_premium_rounded,
                    color: Colors.orangeAccent,
                    size: 11,
                  ),
                  const SizedBox(width: 2),
                  Flexible(
                    child: Text(
                      'Premium Theme',
                      style: TextStyle(
                        color: Colors.orangeAccent.withOpacity(0.85),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final List<Color> activeColors;

  _CircularProgressPainter({
    required this.progress,
    required this.trackColor,
    required this.activeColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 5.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track arc
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    // Active progress arc
    final activePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..shader = SweepGradient(
        colors: activeColors,
        startAngle: -3.14159 / 2,
        endAngle: 2 * 3.14159 - (3.14159 / 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      progress * 2 * 3.14159,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
