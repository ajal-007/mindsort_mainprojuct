import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/progress/provider/progress_provider.dart';
import 'package:mainsupabase_projuct/progress/widgets/progress_line_chart.dart';
import 'package:mainsupabase_projuct/progress/widgets/progress_summery.dart';
import 'package:provider/provider.dart';



class ProgressChartCard extends StatelessWidget {
  const ProgressChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgressProvider>();

    if (provider.isLoading) {
      return Container(
        height: 320,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }

    if (provider.error != null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          provider.error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (provider.progress.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'No assessment history available.',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📈 Progress Over Time',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Overall clarity across your assessments',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 20),

          ProgressLineChart(
            progress: provider.progress,
          ),

          const SizedBox(height: 16),

         ProgressSummary(
  progress: provider.progress,
),
        ],
      ),
    );
  }
}