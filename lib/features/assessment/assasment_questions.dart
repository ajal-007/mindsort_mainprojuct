

import 'package:mainsupabase_projuct/features/assessment/models/assasment_catogory.dart';
import 'package:mainsupabase_projuct/features/assessment/models/assasment_models.dart';

class AssessmentQuestions {
  static  List<AssessmentQuestionModel> questions = [
    AssessmentQuestionModel(
      id: "Q1",
      question: "During the past week, how often did you feel overwhelmed by everything you had to do?",
      category: AssessmentCategory.stress,
      options: [
        AnswerOption(text: "Never", score: 5),
        AnswerOption(text: "Rarely", score: 4),
        AnswerOption(text: "Sometimes", score: 3),
        AnswerOption(text: "Often", score: 2),
        AnswerOption(text: "Almost Always", score: 1),
      ],
    ),

    AssessmentQuestionModel(
      id: "Q2",
      question: "During the past week, how easy was it to stay focused on one task?",
      category: AssessmentCategory.focus,
      options: [
        AnswerOption(text: "Very Difficult", score: 1),
        AnswerOption(text: "Difficult", score: 2),
        AnswerOption(text: "Average", score: 3),
        AnswerOption(text: "Easy", score: 4),
        AnswerOption(text: "Very Easy", score: 5),
      ],
    ),
  ];
}