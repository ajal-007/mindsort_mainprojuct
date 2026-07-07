import 'mental_stage.dart';

class AssessmentResult {
  final double clarityScore;
  final double stressScore;
  final double focusScore;
  final double emotionScore;
  final double productivityScore;

  final double overallClarity;

  final MentalStage stage;

  const AssessmentResult({
    required this.clarityScore,
    required this.stressScore,
    required this.focusScore,
    required this.emotionScore,
    required this.productivityScore,
    required this.overallClarity,
    required this.stage,
  });
}