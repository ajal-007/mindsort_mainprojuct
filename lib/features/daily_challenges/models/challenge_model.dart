import 'challenge_difficulty.dart';

class Challenge {
  final String id;

  final int day;

  final int challengeNumber;

  final String title;

  final String description;

  final int estimatedMinutes;

  final ChallengeDifficulty difficulty;

  final bool completed;

  const Challenge({
    required this.id,
    required this.day,
    required this.challengeNumber,
    required this.title,
    required this.description,
    required this.estimatedMinutes,
    required this.difficulty,
    required this.completed,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] ?? '',
      day: json['challenge_day'] ?? 1,
      challengeNumber: json['challenge_number'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      estimatedMinutes: json['estimated_minutes'] ?? json['estimatedMinutes'] ?? 5,
      difficulty: ChallengeDifficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => ChallengeDifficulty.easy,
      ),
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challenge_day': day,
      'challenge_number': challengeNumber,
      'title': title,
      'description': description,
      'estimated_minutes': estimatedMinutes,
      'difficulty': difficulty.name,
      'completed': completed,
    };
  }
}