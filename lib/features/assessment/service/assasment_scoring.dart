
import 'package:mainsupabase_projuct/features/assessment/models/assasment_answer.dart';
import 'package:mainsupabase_projuct/features/assessment/models/assasment_catogory.dart';
import 'package:mainsupabase_projuct/features/assessment/models/assasment_models.dart';
import 'package:mainsupabase_projuct/features/assessment/models/assasment_result.dart';

import '../models/mental_stage.dart';

class AssessmentScoringService {
  AssessmentResult calculate({
    required List<AssessmentQuestionModel> questions,
    required Map<String, AssessmentAnswer> answers,
  }) {
    double clarity = 0;
    double stress = 0;
    double focus = 0;
    double emotion = 0;
    double productivity = 0;

    int clarityQuestions = 0;
    int stressQuestions = 0;
    int focusQuestions = 0;
    int emotionQuestions = 0;
    int productivityQuestions = 0;

    for (final question in questions) {
      final answer = answers[question.id];

      if (answer == null) continue;

      switch (question.category) {
        case AssessmentCategory.clarity:
          clarity += answer.selectedScore;
          clarityQuestions++;
          break;

        case AssessmentCategory.stress:
          stress += answer.selectedScore;
          stressQuestions++;
          break;

        case AssessmentCategory.focus:
          focus += answer.selectedScore;
          focusQuestions++;
          break;

        case AssessmentCategory.emotion:
          emotion += answer.selectedScore;
          emotionQuestions++;
          break;

        case AssessmentCategory.productivity:
          productivity += answer.selectedScore;
          productivityQuestions++;
          break;
      }
    }

    final clarityPercent =
        _toPercentage(clarity, clarityQuestions);

    final stressPercent =
        _toPercentage(stress, stressQuestions);

    final focusPercent =
        _toPercentage(focus, focusQuestions);

    final emotionPercent =
        _toPercentage(emotion, emotionQuestions);

    final productivityPercent =
        _toPercentage(productivity, productivityQuestions);

    final overall =
        (clarityPercent * 0.30) +
        (focusPercent * 0.25) +
        (stressPercent * 0.20) +
        (emotionPercent * 0.15) +
        (productivityPercent * 0.10);

    return AssessmentResult(
      clarityScore: clarityPercent,
      stressScore: stressPercent,
      focusScore: focusPercent,
      emotionScore: emotionPercent,
      productivityScore: productivityPercent,
      overallClarity: overall,
      stage: _getMentalStage(overall),
    );
  }

  double _toPercentage(double score, int totalQuestions) {
    if (totalQuestions == 0) return 0;

    final maxScore = totalQuestions * 5;

    return (score / maxScore) * 100;
  }

  MentalStage _getMentalStage(double score) {
    if (score <= 20) {
      return MentalStage.critical;
    }

    if (score <= 40) {
      return MentalStage.overwhelmed;
    }

    if (score <= 60) {
      return MentalStage.recovering;
    }

    if (score <= 80) {
      return MentalStage.stable;
    }

    return MentalStage.thriving;
  }
}