enum MentalStage {
  critical,
  overwhelmed,
  recovering,
  stable,
  thriving,
}

extension MentalStageExtension on MentalStage {
  String get title {
    switch (this) {
      case MentalStage.critical:
        return 'Critical';

      case MentalStage.overwhelmed:
        return 'Overwhelmed';

      case MentalStage.recovering:
        return 'Recovering';

      case MentalStage.stable:
        return 'Stable';

      case MentalStage.thriving:
        return 'Thriving';
    }
  }

  String get description {
    switch (this) {
      case MentalStage.critical:
        return 'You are currently experiencing a very high level of mental overload. Focus on small, manageable steps to regain stability.';

      case MentalStage.overwhelmed:
        return 'You are facing noticeable stress and mental clutter. Reducing pressure and organizing your thoughts should be your priority.';

      case MentalStage.recovering:
        return 'You are making progress. Continue building healthy routines and consistent habits.';

      case MentalStage.stable:
        return 'You are generally organized and emotionally balanced. Keep strengthening your daily habits.';

      case MentalStage.thriving:
        return 'You have excellent mental clarity and productivity. Continue maintaining your healthy routines and personal growth.';
    }
  }
}