import 'package:flutter/foundation.dart';

@immutable
class ChartPoint {
  /// X-axis value
  final double x;

  /// Y-axis value
  final double y;

  /// Optional label (e.g. "Assessment 1", "Week 2", "Jan")
  final String? label;

  const ChartPoint({
    required this.x,
    required this.y,
    this.label,
  });

  ChartPoint copyWith({
    double? x,
    double? y,
    String? label,
  }) {
    return ChartPoint(
      x: x ?? this.x,
      y: y ?? this.y,
      label: label ?? this.label,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ChartPoint &&
            runtimeType == other.runtimeType &&
            x == other.x &&
            y == other.y &&
            label == other.label;
  }

  @override
  int get hashCode => Object.hash(x, y, label);

  @override
  String toString() {
    return 'ChartPoint(x: $x, y: $y, label: $label)';
  }
}