import 'package:flutter/material.dart';

class ChartLoading extends StatelessWidget {
  const ChartLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Stack(
        children: [
          // Horizontal Grid Lines
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                5,
                (_) => Container(
                  height: 1,
                  color: Colors.white.withOpacity(.05),
                ),
              ),
            ),
          ),

          // Fake Chart Line
          Center(
            child: Opacity(
              opacity: .35,
              child: Icon(
                Icons.show_chart_rounded,
                size: 90,
                color: Colors.white.withOpacity(.25),
              ),
            ),
          ),

          // Loading Indicator
          const Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 34,
              height: 34,
              child: CircularProgressIndicator(
                strokeWidth: 3,
              ),
            ),
          ),

          // Bottom Labels
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                5,
                (_) => Container(
                  width: 22,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),

          // Left Labels
          Positioned(
            top: 8,
            bottom: 20,
            left: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                5,
                (_) => Container(
                  width: 18,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}