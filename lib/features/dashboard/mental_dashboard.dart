import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/features/dashboard/provider/ai_dashboard_provider.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_text.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_duration.dart';
import '../../core/theme/app_text_styles.dart';
import 'provider/dashboard_provider.dart';

class Insight extends StatefulWidget {
  const Insight({super.key});

  @override
  State<Insight> createState() => _InsightState();
}

class _InsightState extends State<Insight> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardProvider>();
    final aiProvider = context.watch<AiDashboardProvider>();

    if (dashboardProvider.dashboard != null &&
        aiProvider.insight == null &&
        !aiProvider.isLoading &&
        aiProvider.error == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.read<AiDashboardProvider>().generateInsight(dashboardProvider.dashboard!);
        }
      });
    }

    if (dashboardProvider.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.transparent,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryAccent),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxxl, vertical: AppSizes.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppText.mentalAnalytics,
                style: AppTextStyles.insightTitle,
              ),
              const SizedBox(height: AppSizes.sxs),
              Text(
                AppText.aiWorkspaceSub,
                style: AppTextStyles.insightSub,
              ),
              const SizedBox(height: AppSizes.giant),

              _buildClarityOverviewCard(
  dashboardProvider,
  aiProvider,
),
              const SizedBox(height: AppSizes.xxxl),
              
              // _buildFocusGraphCard(dashboardProvider),
              // const SizedBox(height: AppSizes.xxxl),

              // _buildMetricsGrid(dashboardProvider),
              // const SizedBox(height: AppSizes.xxxl),

              const Text(
                AppText.neuromorphicAdvice,
                style: AppTextStyles.insightSectionTitle,
              ),
              const SizedBox(height: AppSizes.md),

              // Column(
              //   children: dashboardProvider.adviceCards.map((card) {
              //     final isPeak = card['type'] == 'peak';
              //     return Padding(
              //       padding: const EdgeInsets.only(bottom: AppSizes.md),
              //       child: _buildAdviceCard(
              //         title: card['title']!,
              //         desc: card['desc']!,
              //         icon: isPeak ? AppIcons.twilight : AppIcons.psychology,
              //         color: isPeak ? AppColors.secondaryAccent : AppColors.primaryAccent,
              //       ),
              //     );
              //   }).toList(),
              // ),
              const SizedBox(height: AppSizes.xxxl),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildClarityOverviewCard(
  DashboardProvider dashboardProvider,
  AiDashboardProvider aiProvider,
) {
  final dashboard = dashboardProvider.dashboard;

  if (dashboard == null) {
    return const SizedBox.shrink();
  }

  return Container(
    padding: const EdgeInsets.all(AppSizes.xxxl),
    decoration: BoxDecoration(
      color: AppColors.white.withOpacity(0.04),
      borderRadius: AppRadius.r28,
      border: Border.all(
        color: AppColors.white.withOpacity(0.08),
      ),
    ),
    child: Row(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: 0,
            end: dashboard.overallClarity,
          ),
          duration: AppDuration.insightEntrance,
          curve: Curves.easeOutCubic,
          builder: (context, clarityValue, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 90,
                  height: 90,
                  child: CustomPaint(
                    painter: _ClarityRingPainter(
                      percentage: clarityValue,
                      ringColor: AppColors.primaryAccent,
                      trackColor: AppColors.white.withOpacity(0.05),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${clarityValue.toInt()}%',
                      style: AppTextStyles.insightClarityVal,
                    ),
                    Text(
                      AppText.clarityLabel,
                      style: AppTextStyles.insightClarityLabel,
                    ),
                  ],
                ),
              ],
            );
          },
        ),

        const SizedBox(width: AppSizes.xxxl),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Current Mental Stage",
                style: AppTextStyles.insightClarityCardTitle,
              ),

              const SizedBox(height: AppSizes.xs),

              Text(
                dashboard.mentalStage,
                style: AppTextStyles.insightMetricValue,
              ),

              const SizedBox(height: AppSizes.md),

              if (aiProvider.isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
                  ),
                ),

              if (!aiProvider.isLoading &&
                  aiProvider.insight != null)
                Text(
                  aiProvider.insight!.summary,
                  style: AppTextStyles.insightClarityCardDesc,
                ),

              if (!aiProvider.isLoading &&
                  aiProvider.error != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.orangeAccent,
                          size: 16,
                        ),
                        const SizedBox(width: AppSizes.xs),
                        Expanded(
                          child: Text(
                            'AI Insight Unavailable',
                            style: TextStyle(
                              color: AppColors.orangeAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      aiProvider.error!.replaceFirst('Exception: ', ''),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    InkWell(
                      onTap: () {
                        context.read<AiDashboardProvider>().generateInsight(dashboardProvider.dashboard!);
                      },
                      borderRadius: AppRadius.r8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.xs),
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccent.withOpacity(0.1),
                          borderRadius: AppRadius.r8,
                          border: Border.all(
                            color: AppColors.primaryAccent.withOpacity(0.3),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.refresh_rounded,
                              color: AppColors.primaryAccent,
                              size: 14,
                            ),
                            SizedBox(width: AppSizes.xs),
                            Text(
                              'Try Again',
                              style: TextStyle(
                                color: AppColors.primaryAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

  // Widget _buildFocusGraphCard(DashboardProvider provider) {
  //   return Container(
  //     padding: const EdgeInsets.all(AppSizes.xxxl),
  //     decoration: BoxDecoration(
  //       color: AppColors.white.withOpacity(0.04),
  //       borderRadius: AppRadius.r28,
  //       border: Border.all(
  //         color: AppColors.white.withOpacity(0.08),
  //       ),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   provider.focusMetrics['title'] ?? AppText.weeklyFocusTitle,
  //                   style: AppTextStyles.insightFocusTitle,
  //                 ),
  //                 const SizedBox(height: AppSizes.xxs),
  //                 Text(
  //                   provider.focusMetrics['sub'] ?? AppText.avgDeepWorkSub,
  //                   style: AppTextStyles.insightFocusSub,
  //                 ),
  //               ],
  //             ),
  //             Container(
  //               padding: const EdgeInsets.symmetric(horizontal: AppSizes.msm, vertical: AppSizes.xs),
  //               decoration: BoxDecoration(
  //                 color: AppColors.secondaryAccent.withOpacity(0.12),
  //                 borderRadius: AppRadius.r8,
  //               ),
  //               child: Text(
  //                 provider.focusMetrics['growth'] ?? AppText.weeklyFocusGrowth,
  //                 style: AppTextStyles.insightFocusPercent,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: AppSizes.xxxl),
          
  //         SizedBox(
  //           height: 140,
  //           width: double.infinity,
  //           child: CustomPaint(
  //             painter: _FocusCurvePainter(
  //               curveColor: AppColors.secondaryAccent,
  //               accentColor: AppColors.primaryAccent,
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: AppSizes.md),
          
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text('Mon', style: TextStyle(color: AppColors.white.withOpacity(0.3), fontSize: 11)),
  //             Text('Tue', style: TextStyle(color: AppColors.white.withOpacity(0.3), fontSize: 11)),
  //             Text('Wed', style: TextStyle(color: AppColors.white.withOpacity(0.3), fontSize: 11)),
  //             Text('Thu', style: TextStyle(color: AppColors.white.withOpacity(0.3), fontSize: 11)),
  //             Text('Fri', style: TextStyle(color: AppColors.white.withOpacity(0.3), fontSize: 11)),
  //             Text('Sat', style: TextStyle(color: AppColors.white.withOpacity(0.3), fontSize: 11)),
  //             Text('Sun', style: TextStyle(color: AppColors.white.withOpacity(0.3), fontSize: 11)),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildMetricsGrid(DashboardProvider provider) {
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       final double cardWidth = (constraints.maxWidth - 16) / 2;
  //       return Wrap(
  //         spacing: AppSizes.lg,
  //         runSpacing: AppSizes.lg,
  //         children: [
  //           _buildMetricTile(
  //             width: cardWidth,
  //             title: provider.streakMetrics['title'] ?? AppText.streakTitle,
  //             value: provider.streakMetrics['value'] ?? AppText.streakValue,
  //             sub: provider.streakMetrics['sub'] ?? AppText.streakSub,
  //             icon: AppIcons.fire,
  //             color: AppColors.orangeAccent,
  //           ),
  //           _buildMetricTile(
  //             width: cardWidth,
  //             title: provider.structuredMetrics['title'] ?? AppText.structuredTitle,
  //             value: provider.structuredMetrics['value'] ?? AppText.structuredValue,
  //             sub: provider.structuredMetrics['sub'] ?? AppText.structuredSub,
  //             icon: AppIcons.rule,
  //             color: AppColors.secondaryAccent,
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Widget _buildMetricTile({
  //   required double width,
  //   required String title,
  //   required String value,
  //   required String sub,
  //   required IconData icon,
  //   required Color color,
  // }) {
  //   return Container(
  //     width: width,
  //     padding: const EdgeInsets.all(AppSizes.xxl),
  //     decoration: BoxDecoration(
  //       color: AppColors.white.withOpacity(0.04),
  //       borderRadius: AppRadius.r24,
  //       border: Border.all(
  //         color: AppColors.white.withOpacity(0.08),
  //       ),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               title,
  //               style: AppTextStyles.insightMetricTitle,
  //             ),
  //             Icon(icon, color: color, size: 20),
  //           ],
  //         ),
  //         const SizedBox(height: AppSizes.mlg),
  //         Text(
  //           value,
  //           style: AppTextStyles.insightMetricValue,
  //         ),
  //         const SizedBox(height: AppSizes.xs),
  //         Text(
  //           sub,
  //           style: AppTextStyles.insightMetricSub,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildAdviceCard({
  //   required String title,
  //   required String desc,
  //   required IconData icon,
  //   required Color color,
  // }) {
  //   return Container(
  //     padding: const EdgeInsets.all(AppSizes.xl),
  //     decoration: BoxDecoration(
  //       color: AppColors.white.withOpacity(0.04),
  //       borderRadius: AppRadius.r20,
  //       border: Border.all(
  //         color: AppColors.white.withOpacity(0.08),
  //       ),
  //     ),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(AppSizes.msm),
  //           decoration: BoxDecoration(
  //             color: color.withOpacity(0.12),
  //             borderRadius: AppRadius.r12,
  //           ),
  //           child: Icon(icon, color: color, size: 22),
  //         ),
  //         const SizedBox(width: AppSizes.lg),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 title,
  //                 style: AppTextStyles.insightAdviceTitle,
  //               ),
  //               const SizedBox(height: AppSizes.sxs),
  //               Text(
  //                 desc,
  //                 style: AppTextStyles.insightAdviceDesc,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class _ClarityRingPainter extends CustomPainter {
  final double percentage;
  final Color ringColor;
  final Color trackColor;

  _ClarityRingPainter({
    required this.percentage,
    required this.ringColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 7.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    final activePaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final sweepAngle = (percentage / 100) * 2 * 3.14159265;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159265 / 2,
      sweepAngle,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(_ClarityRingPainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}

class _FocusCurvePainter extends CustomPainter {
  final Color curveColor;
  final Color accentColor;

  _FocusCurvePainter({
    required this.curveColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.white.withOpacity(0.02)
      ..strokeWidth = 0.8;

    final horizontalGridSpacing = size.height / 4;
    for (double i = 0; i <= size.height; i += horizontalGridSpacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.16, size.height * 0.55),
      Offset(size.width * 0.33, size.height * 0.4),
      Offset(size.width * 0.5, size.height * 0.6),
      Offset(size.width * 0.66, size.height * 0.25),
      Offset(size.width * 0.83, size.height * 0.3),
      Offset(size.width, size.height * 0.1),
    ];

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );
    }

    final gradientPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          curveColor.withOpacity(0.2),
          curveColor.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(gradientPath, fillPaint);

    final strokePaint = Paint()
      ..color = curveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, strokePaint);

    final dotPaint = Paint()..color = accentColor;
    final dotOuterPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var point in points) {
      canvas.drawCircle(point, 4, dotPaint);
      canvas.drawCircle(point, 5, dotOuterPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
