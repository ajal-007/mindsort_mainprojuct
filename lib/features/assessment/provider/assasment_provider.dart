import 'package:flutter/material.dart';

import 'package:mainsupabase_projuct/features/assessment/assasment_questions.dart';
import 'package:mainsupabase_projuct/features/assessment/models/assasment_answer.dart';
import 'package:mainsupabase_projuct/features/assessment/models/assasment_models.dart';

class AssessmentProvider extends ChangeNotifier {
  final List<AssessmentQuestionModel> _questions =
      AssessmentQuestions.questions;

  final Map<String, AssessmentAnswer> _answers = {};

  int _currentIndex = 0;

  List<AssessmentQuestionModel> get questions => _questions;

  Map<String, AssessmentAnswer> get answers => _answers;

  int get currentIndex => _currentIndex;

  AssessmentQuestionModel get currentQuestion =>
      _questions[_currentIndex];

  bool get hasPrevious => _currentIndex > 0;

  bool get hasNext =>
      _currentIndex < _questions.length - 1;

  bool get isCompleted =>
      _answers.length == _questions.length;

  double get progress =>
      (_currentIndex + 1) / _questions.length;

  void selectAnswer(int score) {
    _answers[currentQuestion.id] = AssessmentAnswer(
      questionId: currentQuestion.id,
      selectedScore: score,
    );

    notifyListeners();
  }

  bool isSelected(int score) {
    return _answers[currentQuestion.id]?.selectedScore ==
        score;
  }

  void nextQuestion() {
    if (hasNext) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (hasPrevious) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void reset() {
    _currentIndex = 0;
    _answers.clear();
    notifyListeners();
  }

  /// Starts a completely new assessment.
  void startNewAssessment() {
    _currentIndex = 0;
    _answers.clear();
    notifyListeners();
  }
}