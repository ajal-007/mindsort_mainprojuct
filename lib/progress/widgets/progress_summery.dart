import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/progress/models/progress_point_model.dart';

class ProgressSummary extends StatelessWidget {
  final List<ProgressPoint> progress;

  const ProgressSummary({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    if (progress.isEmpty) {
      return const SizedBox.shrink();
    }

    final latest = progress.last.overallClarity;
    final highest = progress
        .map((e) => e.overallClarity)
        .reduce((a, b) => a > b ? a : b);

    return Row(
      children: [
        Expanded(
          child: _buildItem(
            "Latest",
            "${latest.toStringAsFixed(0)}%",
            Icons.trending_up,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _buildItem(
            "Highest",
            "${highest.toStringAsFixed(0)}%",
            Icons.emoji_events,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _buildItem(
            "Assessments",
            progress.length.toString(),
            Icons.assignment,
          ),
        ),
      ],
    );
  }

  Widget _buildItem(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(.08),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.cyanAccent,
            size: 22,
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}