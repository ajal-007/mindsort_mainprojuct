enum ChallengeStatus {
  completed,
  today,
  locked,
  milestone,
}

class ChallengeNodeModel {
  final int dayNumber;
  final String title;
  final ChallengeStatus status;
  final String reward;
  final bool isMilestone;
  final String challengeType;
  final int stars; // Rating out of 3 stars
  final String description;

  ChallengeNodeModel({
    required this.dayNumber,
    required this.title,
    required this.status,
    required this.reward,
    required this.isMilestone,
    required this.challengeType,
    required this.stars,
    required this.description,
  });
}
