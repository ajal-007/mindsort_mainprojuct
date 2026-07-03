import 'dart:async';
import 'package:flutter/material.dart';
import '../core/constants/app_duration.dart';
import '../core/constants/app_text.dart';
import '../repositories/assessment_repository.dart';

class AssessmentProvider extends ChangeNotifier {
  final AssessmentRepository _assessmentRepository = AssessmentRepository();

  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> get messages => _messages;

  bool _isTyping = false;
  bool get isTyping => _isTyping;

  AssessmentProvider() {
    loadMessages();
  }

  Future<void> loadMessages() async {
    _messages = await _assessmentRepository.fetchMessages();
    notifyListeners();
  }

  Future<void> sendMessage(String text, {required VoidCallback onResponseReceived}) async {
    if (text.trim().isEmpty) return;

    final userMessage = {
      'sender': 'user',
      'text': text,
      'time': AppText.timeJustNow,
    };

    await _assessmentRepository.addMessage(userMessage);
    _messages.add(userMessage);
    _isTyping = true;
    notifyListeners();

    onResponseReceived();

    Future.delayed(AppDuration.coachResponseDelay, () async {
      final responseText = await _assessmentRepository.simulateCoachResponse(text);
      final coachMessage = {
        'sender': 'coach',
        'text': responseText,
        'time': AppText.timeJustNow,
      };

      await _assessmentRepository.addMessage(coachMessage);
      _messages.add(coachMessage);
      _isTyping = false;
      notifyListeners();

      onResponseReceived();
    });
  }
}
