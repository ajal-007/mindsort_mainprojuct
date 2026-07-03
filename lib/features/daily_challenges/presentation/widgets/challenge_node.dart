import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../models/challenge_node_model.dart';

class ChallengeNode extends StatefulWidget {
  final ChallengeNodeModel node;
  final VoidCallback? onTap;

  const ChallengeNode({
    super.key,
    required this.node,
    this.onTap,
  });

  @override
  State<ChallengeNode> createState() => _ChallengeNodeState();
}

class _ChallengeNodeState extends State<ChallengeNode> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _glowPulse;
  late final Animation<double> _arrowSlide;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _glowPulse = Tween<double>(begin: 4.0, end: 14.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _arrowSlide = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.node.status == ChallengeStatus.today) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLocked = widget.node.status == ChallengeStatus.locked;

    return GestureDetector(
      onTap: isLocked ? null : widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Upper details (Today banner or Milestone crown)
          _buildUpperDecoration(),
          const SizedBox(height: 4),

          // Central glowing circle node
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              _buildNodeCircle(),
              // Checkmark indicator for completed challenges
              if (widget.node.status == ChallengeStatus.completed)
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: _buildCheckmarkBadge(),
                ),
              // Pointer arrow on the left for today's challenge
              if (widget.node.status == ChallengeStatus.today)
                Positioned(
                  left: -32,
                  child: AnimatedBuilder(
                    animation: _arrowSlide,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_arrowSlide.value, 0),
                        child: child,
                      );
                    },
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.electricCyan,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),

          // Stars rating below the node
          _buildStarsRow(),
          const SizedBox(height: 2),

          // Day text label (e.g. Day 1, Day 7)
          _buildTextLabel(),
        ],
      ),
    );
  }

  Widget _buildUpperDecoration() {
    if (widget.node.status == ChallengeStatus.today) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.challengePurple,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.challengePurple.withOpacity(0.4),
              blurRadius: 8,
            )
          ],
        ),
        child: const Text(
          'Today',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (widget.node.isMilestone) {
      final color = widget.node.dayNumber == 7 ? Colors.orangeAccent : AppColors.challengePurple;
      return Icon(
        Icons.workspace_premium_rounded,
        color: color,
        size: 22,
        shadows: [
          Shadow(
            color: color.withOpacity(0.6),
            blurRadius: 10,
          )
        ],
      );
    }

    return const SizedBox(height: 16); // Balances out spacing
  }

  Widget _buildNodeCircle() {
    Color baseColor;
    List<BoxShadow> glowEffects = [];

    switch (widget.node.status) {
      case ChallengeStatus.completed:
        baseColor = AppColors.electricCyan;
        glowEffects = [
          BoxShadow(
            color: AppColors.electricCyan.withOpacity(0.35),
            blurRadius: 12,
          )
        ];
        break;
      case ChallengeStatus.today:
        baseColor = AppColors.challengePurple;
        break;
      case ChallengeStatus.milestone:
        baseColor = widget.node.dayNumber == 7 ? Colors.orangeAccent : AppColors.challengePurple;
        glowEffects = [
          BoxShadow(
            color: baseColor.withOpacity(0.45),
            blurRadius: 15,
            spreadRadius: 2,
          )
        ];
        break;
      case ChallengeStatus.locked:
        baseColor = Colors.white.withOpacity(0.08);
        break;
    }

    final double size = widget.node.status == ChallengeStatus.today ? 64 : 54;

    if (widget.node.status == ChallengeStatus.today) {
      return AnimatedBuilder(
        animation: _glowPulse,
        builder: (context, child) {
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.challengesBackground,
              border: Border.all(
                color: baseColor,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.challengePurple.withOpacity(0.55),
                  blurRadius: _glowPulse.value,
                  spreadRadius: _glowPulse.value / 4,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: _buildNodeContent(),
          );
        },
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.node.status == ChallengeStatus.locked
            ? Colors.white.withOpacity(0.03)
            : AppColors.challengesBackground,
        border: Border.all(
          color: widget.node.status == ChallengeStatus.locked
              ? Colors.white.withOpacity(0.12)
              : baseColor,
          width: 2,
        ),
        boxShadow: glowEffects,
      ),
      alignment: Alignment.center,
      child: _buildNodeContent(),
    );
  }

  Widget _buildNodeContent() {
    if (widget.node.status == ChallengeStatus.locked) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${widget.node.dayNumber}',
            style: TextStyle(
              color: AppColors.white.withOpacity(0.25),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 1),
          Icon(
            Icons.lock_outline_rounded,
            color: AppColors.white.withOpacity(0.25),
            size: 11,
          ),
        ],
      );
    }

    return Text(
      '${widget.node.dayNumber}',
      style: TextStyle(
        color: AppColors.white,
        fontSize: widget.node.status == ChallengeStatus.today ? 18 : 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCheckmarkBadge() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.electricCyan,
      ),
      child: const Icon(
        Icons.check,
        color: AppColors.challengesBackground,
        size: 10,
        weight: 3.0,
      ),
    );
  }

  Widget _buildStarsRow() {
    Color starColor;
    switch (widget.node.status) {
      case ChallengeStatus.completed:
        starColor = AppColors.electricCyan;
        break;
      case ChallengeStatus.today:
        starColor = AppColors.challengePurple;
        break;
      case ChallengeStatus.milestone:
        starColor = widget.node.dayNumber == 7 ? Colors.orangeAccent : AppColors.challengePurple;
        break;
      case ChallengeStatus.locked:
        starColor = AppColors.white.withOpacity(0.08);
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final active = index < widget.node.stars;
        return Icon(
          Icons.star_rounded,
          color: active ? starColor : Colors.white.withOpacity(0.08),
          size: 12,
        );
      }),
    );
  }

  Widget _buildTextLabel() {
    Color labelColor;
    if (widget.node.status == ChallengeStatus.locked) {
      labelColor = AppColors.white.withOpacity(0.25);
    } else if (widget.node.status == ChallengeStatus.today) {
      labelColor = AppColors.white;
    } else if (widget.node.dayNumber == 7) {
      labelColor = Colors.orangeAccent;
    } else {
      labelColor = AppColors.white.withOpacity(0.55);
    }

    return Text(
      'Day ${widget.node.dayNumber}',
      style: TextStyle(
        color: labelColor,
        fontSize: 10,
        fontWeight: widget.node.status == ChallengeStatus.today ? FontWeight.bold : FontWeight.w500,
      ),
    );
  }
}
