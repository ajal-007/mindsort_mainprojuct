import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/progress/models/progress_point_model.dart';


class ProgressLineChart extends StatelessWidget {
  final List<ProgressPoint> progress;

  const ProgressLineChart({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    if (progress.isEmpty) {
      return const Center(
        child: Text(
          'No progress data available',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final spots = progress
        .map(
          (e) => FlSpot(
            e.assessmentNumber.toDouble(),
            e.overallClarity,
          ),
        )
        .toList();

    return SizedBox(
      height: 240,
      child: LineChart(
        LineChartData(
          minX: 1,
          maxX: progress.last.assessmentNumber.toDouble(),
          minY: 0,
          maxY: 100,

          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.white10,
                strokeWidth: 1,
              );
            },
          ),

          borderData: FlBorderData(
            show: false,
          ),

          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),

            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                reservedSize: 34,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                  );
                },
              ),
            ),

            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "A${value.toInt()}",
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  return LineTooltipItem(
                    'Assessment ${spot.x.toInt()}\n'
                    '${spot.y.toStringAsFixed(0)}%',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),

          lineBarsData: [
            LineChartBarData(
              spots: spots,

              isCurved: true,

              barWidth: 4,

              color: const Color(0xff7C4DFF),

              isStrokeCapRound: true,

              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xff7C4DFF).withOpacity(.35),
                    Colors.transparent,
                  ],
                ),
              ),

              dotData: FlDotData(
                show: true,
                getDotPainter:
                    (spot, percent, bar, index) => FlDotCirclePainter(
                  radius: 5,
                  color: const Color(0xff00E5FF),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}