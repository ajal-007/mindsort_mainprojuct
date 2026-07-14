import '../models/challenge_difficulty.dart';

class ChallengeDifficultyService {
  static ChallengeDifficulty getDifficulty(int currentDay) {
    if (currentDay >= 1 && currentDay <= 5) {
      return ChallengeDifficulty.veryEasy;
    }

    if (currentDay >= 6 && currentDay <= 10) {
      return ChallengeDifficulty.easy;
    }

    if (currentDay >= 11 && currentDay <= 15) {
      return ChallengeDifficulty.medium;
    }

    if (currentDay >= 16 && currentDay <= 20) {
      return ChallengeDifficulty.hard;
    }

    return ChallengeDifficulty.expert;
  }
}