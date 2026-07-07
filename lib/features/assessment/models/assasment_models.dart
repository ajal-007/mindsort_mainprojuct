import 'package:mainsupabase_projuct/features/assessment/models/assasment_catogory.dart';

class AssessmentQuestionModel {
  final String id;
  final String question;
  final AssessmentCategory category;
  final List<AnswerOption> options;

  AssessmentQuestionModel({
    required this.id,
    required this.question,
    required this.category,
    required this.options,
  });
}

class AnswerOption {
  final String text;
  final int score;

  AnswerOption({
    required this.text,
    required this.score,
  });
}