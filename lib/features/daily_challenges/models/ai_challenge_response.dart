import 'package:mainsupabase_projuct/features/daily_challenges/models/challenge_model.dart';



class AIChallengeResponse {
  final List<Challenge> challenges;

  const AIChallengeResponse({
    required this.challenges,
  });

  factory AIChallengeResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return AIChallengeResponse(
      challenges: (json['challenges'] as List)
          .map(
            (e) => Challenge.fromJson(e),
          )
          .toList(),
    );
  }
}