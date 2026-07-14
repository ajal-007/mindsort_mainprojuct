enum ChallengeDifficulty {
  veryEasy,
  easy,
  medium,
  hard,
  expert,
}

extension ChallengeDifficultyExtension on ChallengeDifficulty {
  String get title {
    switch (this) {
      case ChallengeDifficulty.veryEasy:
        return 'Very Easy';

      case ChallengeDifficulty.easy:
        return 'Easy';

      case ChallengeDifficulty.medium:
        return 'Medium';

      case ChallengeDifficulty.hard:
        return 'Hard';

      case ChallengeDifficulty.expert:
        return 'Expert';
    }
  }

  int get stars {
    switch (this) {
      case ChallengeDifficulty.veryEasy:
        return 1;

      case ChallengeDifficulty.easy:
        return 2;

      case ChallengeDifficulty.medium:
        return 3;

      case ChallengeDifficulty.hard:
        return 4;

      case ChallengeDifficulty.expert:
        return 5;
    }
  }
}