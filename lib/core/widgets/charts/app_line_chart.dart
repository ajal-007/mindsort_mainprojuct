import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'chart_point.dart';

class AppLineChart extends StatelessWidget {
  final List<ChartPoint> points;

  final double minY;
  final double maxY;

  final bool showGrid;
  final bool showDots;
  final bool isCurved;

  final Color startColor;
  final Color endColor;

  final String Function(double value)? bottomTitleBuilder;
  final String Function(double value)? leftTitleBuilder;

  const AppLineChart({
    super.key,
    required this.points,
    this.minY = 0,
    this.maxY = 100,
    this.showGrid = true,
    this.showDots = true,
    this.isCurved = true,
    this.startColor = const Color(0xff7C4DFF),
    this.endColor = const Color(0xff00E5FF),
    this.bottomTitleBuilder,
    this.leftTitleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const SizedBox(
        height: 240,
        child: Center(
          child: Text(
            "No chart data available",
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    return SizedBox(
      height: 240,
      child: LineChart(
        LineChartData(
          minX: points.first.x,
          maxX: points.last.x,
          minY: minY,
          maxY: maxY,

          borderData: FlBorderData(show: false),

          clipData: const FlClipData.all(),

          gridData: FlGridData(
            show: showGrid,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: Colors.white.withOpacity(.08), strokeWidth: 1),
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
                    leftTitleBuilder?.call(value) ?? value.toInt().toString(),
                    style: const TextStyle(color: Colors.white60, fontSize: 11),
                  );
                },
              ),
            ),

            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      bottomTitleBuilder?.call(value) ??
                          value.toInt().toString(),
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
              getTooltipColor: (_) => Colors.black87,
              tooltipPadding: const EdgeInsets.all(10),
              tooltipBorder: BorderSide.none,
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  final point = points.firstWhere((e) => e.x == spot.x);

                  return LineTooltipItem(
                    "${point.label ?? "Value"}\n${spot.y.toStringAsFixed(0)}%",
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
              spots: points.map((e) => FlSpot(e.x, e.y)).toList(),

              isCurved: isCurved,

              barWidth: 4,

              gradient: LinearGradient(colors: [startColor, endColor]),

              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [startColor.withOpacity(.30), Colors.transparent],
                ),
              ),

              dotData: FlDotData(
                show: showDots,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 5,
                    color: endColor,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
