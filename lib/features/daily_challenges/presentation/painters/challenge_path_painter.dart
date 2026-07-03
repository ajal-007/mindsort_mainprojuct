import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ChallengePathPainter extends CustomPainter {
  final List<Offset> points;
  final int activeIndex;

  ChallengePathPainter({
    required this.points,
    required this.activeIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    // Draw the overall track path (locked/background)
    final trackPath = _createWindingPath(points);
    final trackPaint = Paint()
      ..color = AppColors.white.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(trackPath, trackPaint);

    final trackBorderPaint = Paint()
      ..color = AppColors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(trackPath, trackBorderPaint);

    // Draw the active/completed path segment
    if (activeIndex >= 0) {
      final activePoints = points.sublist(0, (activeIndex + 1).clamp(1, points.length));
      if (activePoints.length >= 2) {
        final activePath = _createWindingPath(activePoints);

        // Active outer glow
        final glowPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 22.0
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
          ..shader = LinearGradient(
            colors: [
              AppColors.challengeBlue.withOpacity(0.4),
              AppColors.electricCyan.withOpacity(0.4),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
        canvas.drawPath(activePath, glowPaint);

        // Active core line
        final activePaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12.0
          ..strokeCap = StrokeCap.round
          ..shader = const LinearGradient(
            colors: [
              AppColors.challengePurple,
              AppColors.challengeBlue,
              AppColors.electricCyan,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
        canvas.drawPath(activePath, activePaint);
      }
    }
  }

  Path _createWindingPath(List<Offset> pts) {
    final path = Path();
    path.moveTo(pts[0].dx, pts[0].dy);

    for (int i = 0; i < pts.length - 1; i++) {
      final p0 = pts[i];
      final p1 = pts[i + 1];

      // Winding curve control points
      final controlX = (p0.dx + p1.dx) / 2;
      path.cubicTo(
        controlX,
        p0.dy,
        controlX,
        p1.dy,
        p1.dx,
        p1.dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant ChallengePathPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.activeIndex != activeIndex;
  }
}
