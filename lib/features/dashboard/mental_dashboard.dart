import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/features/dashboard/provider/ai_dashboard_provider.dart';
import 'package:mainsupabase_projuct/progress/provider/progress_provider.dart';
import 'package:mainsupabase_projuct/progress/widgets/progress_chart_card.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
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
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) {
      context.read<ProgressProvider>().loadProgress();
    }
  });
}

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
          context.read<AiDashboardProvider>().generateInsight(
            dashboardProvider.dashboard!,
          );
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.xxxl,
            vertical: AppSizes.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppText.mentalAnalytics,
                style: AppTextStyles.insightTitle,
              ),
              const SizedBox(height: AppSizes.sxs),
              Text(AppText.aiWorkspaceSub, style: AppTextStyles.insightSub),
              const SizedBox(height: AppSizes.giant),

              _buildClarityOverviewCard(dashboardProvider, aiProvider),
              const SizedBox(height: AppSizes.xxxl),

              const ProgressChartCard(),

              const SizedBox(height: AppSizes.xxxl),

              const Text(
                AppText.neuromorphicAdvice,
                style: AppTextStyles.insightSectionTitle,
              ),

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
        border: Border.all(color: AppColors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: dashboard.overallClarity),
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
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryAccent,
                      ),
                    ),
                  ),

                if (!aiProvider.isLoading && aiProvider.insight != null)
                  Text(
                    aiProvider.insight!.summary,
                    style: AppTextStyles.insightClarityCardDesc,
                  ),

                if (!aiProvider.isLoading && aiProvider.error != null)
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
                          context.read<AiDashboardProvider>().generateInsight(
                            dashboardProvider.dashboard!,
                          );
                        },
                        borderRadius: AppRadius.r8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.md,
                            vertical: AppSizes.xs,
                          ),
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
