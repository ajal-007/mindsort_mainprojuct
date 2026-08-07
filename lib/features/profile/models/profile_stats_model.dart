import 'package:flutter/foundation.dart';

@immutable
class ProfileStatsModel {
  final int currentStreak;
  final int assessments;
  final int completedChallenges;

  const ProfileStatsModel({
    required this.currentStreak,
    required this.assessments,
    required this.completedChallenges,
  });

  factory ProfileStatsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProfileStatsModel(
      currentStreak: json['currentStreak'] as int,
      assessments: json['assessments'] as int,
      completedChallenges: json['completedChallenges'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'assessments': assessments,
      'completedChallenges': completedChallenges,
    };
  }

  ProfileStatsModel copyWith({
    int? currentStreak,
    int? assessments,
    int? completedChallenges,
  }) {
    return ProfileStatsModel(
      currentStreak: currentStreak ?? this.currentStreak,
      assessments: assessments ?? this.assessments,
      completedChallenges:
          completedChallenges ?? this.completedChallenges,
    );
  }
}