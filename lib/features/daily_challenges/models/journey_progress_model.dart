import 'package:flutter/foundation.dart';

@immutable
class JourneyProgressModel {
  final int currentDay;
  final int completedDays;
  final int currentStreak;

  const JourneyProgressModel({
    required this.currentDay,
    required this.completedDays,
    required this.currentStreak,
  });

  factory JourneyProgressModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return JourneyProgressModel(
      currentDay: json['currentDay'] as int,
      completedDays: json['completedDays'] as int,
      currentStreak: json['currentStreak'] as int,
    );
  }
}