import 'package:mainsupabase_projuct/features/daily_challenges/models/challenge_model.dart';



class AIChallengeResponse {
  final List<Challenge> challenges;

  const AIChallengeResponse({
    required this.challenges,
  });

  factory AIChallengeResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final challengesList = json['challenges'] as List?;
    final difficulty = json['difficulty'] as String?;
    final currentDay = json['currentDay'] as int?;

    final List<Challenge> parsedChallenges = [];
    if (challengesList != null) {
      for (int i = 0; i < challengesList.length; i++) {
        final item = Map<String, dynamic>.from(challengesList[i]);
        item['challenge_number'] ??= i + 1;
        if (difficulty != null) {
          item['difficulty'] ??= difficulty;
        }
        if (currentDay != null) {
          item['challenge_day'] ??= currentDay;
        }
        parsedChallenges.add(Challenge.fromJson(item));
      }
    }

    return AIChallengeResponse(
      challenges: parsedChallenges,
    );
  }
}