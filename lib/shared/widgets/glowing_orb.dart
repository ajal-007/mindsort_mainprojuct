import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class GlowingOrb extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;
  final bool useRadialGradient;

  const GlowingOrb({
    super.key,
    required this.color,
    required this.size,
    this.opacity = 1.0,
    this.useRadialGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    if (useRadialGradient) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withOpacity(opacity),
              AppColors.transparent,
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(opacity),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(opacity * 1.5),
                blurRadius: size * 0.6,
                spreadRadius: size * 0.1,
              ),
            ],
          ),
        ),
      );
    }
  }
}
