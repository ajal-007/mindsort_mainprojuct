import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../dashboard/provider/dashboard_provider.dart';
import '../../providers/challenge_provider.dart';
import 'challenge_page.dart';

double getXForDay(int day, double width) {
  final double centerX = width / 2;
  final double amplitude = width * 0.22;
  return centerX + amplitude * math.sin(day * 0.5);
}

double getYForDay(int day, double totalHeight) {
  final double stepHeight = 130.0;
  return totalHeight - (day * stepHeight) + 65.0;
}

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    final dashboardProvider = context.read<DashboardProvider>();
    final challengeProvider = context.read<ChallengeProvider>();

    challengeProvider.loadJourneyState().then((_) {
      if (dashboardProvider.dashboard == null) {
        dashboardProvider.loadDashboard();
      }
      _scrollToCurrentDay();
    });
  }

  void _scrollToCurrentDay() {
    if (!mounted) return;

    if (!_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCurrentDay();
      });
      return;
    }

    final challengeProvider = context.read<ChallengeProvider>();
    final currentDay = challengeProvider.currentDay;
    final double stepHeight = 130.0;
    final double totalHeight = 31 * stepHeight;

    // Day 1 is at the bottom, Day 30 at the top
    final double dayY = getYForDay(currentDay, totalHeight);
    final double targetOffset =
        dayY - 300.0; // position it in the middle of viewport
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double minScroll = _scrollController.position.minScrollExtent;

    final double safeOffset = targetOffset.clamp(minScroll, maxScroll);

    _scrollController.animateTo(
      safeOffset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final challengeProvider = context.watch<ChallengeProvider>();

    final currentDay = challengeProvider.currentDay;
    final double stepHeight = 130.0;
    final double totalHeight = 31 * stepHeight;

    if (challengeProvider.isLoading && currentDay == 1) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryAccent),
        ),
      );
    }

    if (challengeProvider.error != null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: _buildErrorState(context, challengeProvider.error!),
      );
    }

    final double progressPercent = (currentDay - 1) / 30.0;
    final int completedDays = currentDay - 1;

    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(currentDay),
            const SizedBox(height: AppSizes.md),
            _buildProgressCard(completedDays, progressPercent),
            const SizedBox(height: AppSizes.md),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double width = constraints.maxWidth;
                    return SizedBox(
                      width: width,
                      height: totalHeight,
                      child: Stack(
                        children: [
                          CustomPaint(
                            size: Size(width, totalHeight),
                            painter: JourneyPathPainter(
                              currentDay: currentDay,
                              totalDays: 30,
                              stepHeight: stepHeight,
                            ),
                          ),
                          for (int d = 1; d <= 30; d++)
                            Positioned(
                              left: getXForDay(d, width) - 40.0,
                              top: getYForDay(d, totalHeight) - 50.0,
                              child: DayNodeWidget(
                                day: d,
                                currentDay: currentDay,
                                onTap: () =>
                                    _handleDayTap(context, d, currentDay),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int currentDay) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSizes.xl,
        right: AppSizes.xl,
        top: AppSizes.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Clarity Journey",
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
                "Active Path: Day $currentDay",
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          _buildStreakBadge(),
        ],
      ),
    );
  }

  Widget _buildStreakBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.orangeAccent.withOpacity(0.1),
        borderRadius: AppRadius.r12,
        border: Border.all(color: AppColors.orangeAccent.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: AppColors.orangeAccent,
            size: 16,
          ),
          const SizedBox(width: AppSizes.xs),
          Consumer<ChallengeProvider>(
            builder: (context, provider, child) {
              final streak = provider.journeyProgress?.currentStreak ?? 0;

              return Text(
                "$streak-Day Streak",
                style: const TextStyle(
                  color: AppColors.orangeAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(int completedDays, double percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.04),
          borderRadius: AppRadius.r20,
          border: Border.all(color: AppColors.white.withOpacity(0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Journey Progress",
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Consumer<ChallengeProvider>(
                  builder: (context, provider, child) {
                    final completedDays =
                        provider.journeyProgress?.completedDays ?? 0;

                    return Text(
                      "$completedDays / 30 Days Completed",
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.6),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: AppColors.white.withOpacity(0.06),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryAccent,
                ),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDayTap(BuildContext context, int day, int currentDay) {
    if (day > currentDay) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.lock_rounded,
                color: AppColors.orangeAccent,
                size: 20,
              ),
              const SizedBox(width: AppSizes.md),
              const Text(
                "Complete previous days to unlock this challenge.",
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.backgroundSheet,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      final provider = context.read<ChallengeProvider>();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChallengePage(day: day)),
      ).then((_) {
        provider.loadJourneyState().then((_) {
          _scrollToCurrentDay();
        });
      });
    }
  }

  Widget _buildErrorState(BuildContext context, String error) {
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
              "Journey Load Interrupted",
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
            ElevatedButton.icon(
              onPressed: () {
                _loadInitialData();
              },
              icon: const Icon(
                Icons.refresh_rounded,
                color: AppColors.white,
                size: 18,
              ),
              label: const Text("Retry Connection"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent.withOpacity(0.12),
                foregroundColor: AppColors.primaryAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.xxl,
                  vertical: AppSizes.md,
                ),
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

class DayNodeWidget extends StatefulWidget {
  final int day;
  final int currentDay;
  final VoidCallback onTap;

  const DayNodeWidget({
    super.key,
    required this.day,
    required this.currentDay,
    required this.onTap,
  });

  @override
  State<DayNodeWidget> createState() => _DayNodeWidgetState();
}

class _DayNodeWidgetState extends State<DayNodeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.day == widget.currentDay) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant DayNodeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.day == widget.currentDay) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = widget.day < widget.currentDay;
    final bool isCurrent = widget.day == widget.currentDay;
    final bool isLocked = widget.day > widget.currentDay;

    Color nodeColor;
    Color glowColor;
    Widget childIcon;

    if (isCompleted) {
      nodeColor = AppColors.challengePurple;
      glowColor = AppColors.challengePurple.withOpacity(0.4);
      childIcon = const Icon(
        Icons.check_rounded,
        color: AppColors.white,
        size: 24,
      );
    } else if (isCurrent) {
      nodeColor = AppColors.primaryAccent;
      glowColor = AppColors.primaryAccent.withOpacity(0.6);
      childIcon = const Icon(
        Icons.play_arrow_rounded,
        color: AppColors.white,
        size: 28,
      );
    } else {
      nodeColor = AppColors.white.withOpacity(0.06);
      glowColor = AppColors.transparent;
      childIcon = Icon(
        Icons.lock_rounded,
        color: AppColors.white.withOpacity(0.3),
        size: 20,
      );
    }

    Widget content = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: isLocked ? AppColors.surfaceDark : nodeColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: isCurrent
              ? AppColors.electricCyan
              : (isCompleted
                    ? AppColors.challengePurple.withOpacity(0.8)
                    : AppColors.white.withOpacity(0.1)),
          width: 2.0,
        ),
        boxShadow: !isLocked
            ? [
                BoxShadow(
                  color: glowColor,
                  blurRadius: isCurrent ? 14 : 8,
                  spreadRadius: isCurrent ? 2 : 0,
                ),
              ]
            : null,
      ),
      child: Center(child: childIcon),
    );

    if (isCurrent) {
      content = Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.electricCyan.withOpacity(0.35),
                      width: 1.5,
                    ),
                  ),
                ),
              );
            },
          ),
          content,
          Positioned(
            bottom: -18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.electricCyan,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.electricCyan.withOpacity(0.4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Text(
                "TODAY",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          const SizedBox(height: 8),
          Text(
            "Day ${widget.day}",
            style: TextStyle(
              color: isLocked
                  ? AppColors.white.withOpacity(0.3)
                  : AppColors.white,
              fontSize: 12,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class JourneyPathPainter extends CustomPainter {
  final int currentDay;
  final int totalDays;
  final double stepHeight;

  JourneyPathPainter({
    required this.currentDay,
    required this.totalDays,
    required this.stepHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double totalHeight = size.height;
    final double width = size.width;

    final Paint lockedPaint = Paint()
      ..color = AppColors.white.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final Paint unlockedPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.challengePurple, AppColors.electricCyan],
      ).createShader(Rect.fromLTWH(0, 0, width, totalHeight))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final Path path = Path();
    for (int d = 1; d <= totalDays; d++) {
      final x = getXForDay(d, width);
      final y = getYForDay(d, totalHeight);
      if (d == 1) {
        path.moveTo(x, y);
      } else {
        final prevX = getXForDay(d - 1, width);
        final prevY = getYForDay(d - 1, totalHeight);
        final midX = (prevX + x) / 2;
        final midY = (prevY + y) / 2;
        path.quadraticBezierTo(prevX, prevY, midX, midY);
      }
    }
    canvas.drawPath(path, lockedPaint);

    if (currentDay > 1) {
      final Path activePath = Path();
      for (int d = 1; d <= currentDay; d++) {
        final x = getXForDay(d, width);
        final y = getYForDay(d, totalHeight);
        if (d == 1) {
          activePath.moveTo(x, y);
        } else {
          final prevX = getXForDay(d - 1, width);
          final prevY = getYForDay(d - 1, totalHeight);
          final midX = (prevX + x) / 2;
          final midY = (prevY + y) / 2;
          activePath.quadraticBezierTo(prevX, prevY, midX, midY);
        }
      }

      final Paint glowPaint = Paint()
        ..shader = const LinearGradient(
          colors: [AppColors.challengePurple, AppColors.electricCyan],
        ).createShader(Rect.fromLTWH(0, 0, width, totalHeight))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12.0
        ..imageFilter = ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0)
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(activePath, glowPaint);
      canvas.drawPath(activePath, unlockedPaint);
    }
  }

  @override
  bool shouldRepaint(covariant JourneyPathPainter oldDelegate) {
    return oldDelegate.currentDay != currentDay;
  }
}
