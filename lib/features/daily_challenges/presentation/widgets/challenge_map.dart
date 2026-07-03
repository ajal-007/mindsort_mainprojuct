import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../models/challenge_node_model.dart';
import '../painters/challenge_path_painter.dart';
import 'challenge_node.dart';

class ChallengeMap extends StatelessWidget {
  final List<ChallengeNodeModel> nodes;
  final int activeDayIndex;
  final Function(ChallengeNodeModel)? onNodeTap;

  const ChallengeMap({
    super.key,
    required this.nodes,
    required this.activeDayIndex,
    this.onNodeTap,
  });

  @override
  Widget build(BuildContext context) {
    // Relative coordinates (dx, dy) for the winding path of 13 mock nodes plus the end goal
    final relativePoints = [
      const Offset(0.18, 0.08), // Day 1
      const Offset(0.38, 0.12), // Day 2
      const Offset(0.58, 0.09), // Day 3
      const Offset(0.80, 0.18), // Day 4
      const Offset(0.48, 0.32), // Day 5
      const Offset(0.18, 0.37), // Day 6 (Today)
      const Offset(0.36, 0.50), // Day 7 (Milestone)
      const Offset(0.60, 0.46), // Day 8
      const Offset(0.80, 0.49), // Day 9
      const Offset(0.16, 0.65), // Day 10
      const Offset(0.36, 0.65), // Day 11
      const Offset(0.56, 0.66), // Day 12 (Milestone)
      const Offset(0.74, 0.65), // Day 13
      const Offset(0.88, 0.77), // Trophy Goal (Day 30)
    ];

    const double mapHeight = 960.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final mapWidth = constraints.maxWidth;

        // Convert relative offsets to absolute screen constraints
        final absolutePoints = relativePoints.map((pt) {
          return Offset(pt.dx * mapWidth, pt.dy * mapHeight);
        }).toList();

        return SizedBox(
          height: mapHeight + 50,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. Winding Road Path
              Positioned.fill(
                child: CustomPaint(
                  painter: ChallengePathPainter(
                    points: absolutePoints,
                    activeIndex: activeDayIndex,
                  ),
                ),
              ),

              // 2. Start Flag Pedestal
              _buildStartFlag(absolutePoints[0]),

              // 3. Challenge Step Nodes
              ...List.generate(nodes.length, (index) {
                final pt = absolutePoints[index];
                final node = nodes[index];
                final isToday = node.status == ChallengeStatus.today;
                final size = isToday ? 64.0 : 54.0;

                return Positioned(
                  left: pt.dx - (size / 2),
                  top: pt.dy - (size / 2) - 15,
                  child: ChallengeNode(
                    node: node,
                    onTap: () => onNodeTap?.call(node),
                  ),
                );
              }),

              // 4. Pedestaled Trophy finish
              _buildGoalTrophy(absolutePoints.last),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStartFlag(Offset day1Pos) {
    return Positioned(
      left: day1Pos.dx - 68,
      top: day1Pos.dy - 68,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.challengePurple,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: AppColors.challengePurple.withOpacity(0.4),
                  blurRadius: 10,
                )
              ],
            ),
            child: const Text(
              'START',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 3,
            height: 22,
            color: AppColors.white.withOpacity(0.5),
          ),
          Container(
            width: 14,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalTrophy(Offset trophyPos) {
    return Positioned(
      left: trophyPos.dx - 45,
      top: trophyPos.dy - 60,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.electricCyan.withOpacity(0.08),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.electricCyan.withOpacity(0.35),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ],
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.electricCyan, AppColors.challengeBlue],
                ).createShader(bounds),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.white,
                  size: 40,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.xs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.electricCyan.withOpacity(0.12),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: AppColors.electricCyan.withOpacity(0.25),
              ),
            ),
            child: const Text(
              'DAY 30',
              style: TextStyle(
                color: AppColors.electricCyan,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
