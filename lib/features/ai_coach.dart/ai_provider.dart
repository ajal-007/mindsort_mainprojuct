import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_duration.dart';
import '../../core/constants/app_text.dart';
import 'ai_repository.dart';

class AiProvider extends ChangeNotifier {
  final  _aiRepository = AiRepository();
  StreamSubscription<AuthState>? _authSubscription;

  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> get messages => _messages;

  bool _isTyping = false;
  bool get isTyping => _isTyping;

  AiProvider() {
    loadMessages();
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedOut) {
        reset();
      }
    });
  }

  void reset() {
    _aiRepository.reset();
    _messages.clear();
    _isTyping = false;
    loadMessages();
  }

  Future<void> loadMessages() async {
    _messages = await _aiRepository.fetchMessages();
    notifyListeners();
  }

  Future<void> sendMessage(String text, {required VoidCallback onResponseReceived}) async {
    if (text.trim().isEmpty) return;

    final userMessage = {
      'sender': 'user',
      'text': text,
      'time': AppText.timeJustNow,
    };

    await _aiRepository.addMessage(userMessage);
    _messages.add(userMessage);
    _isTyping = true;
    notifyListeners();

    onResponseReceived();

    Future.delayed(AppDuration.coachResponseDelay, () async {
      final responseText = await _aiRepository.simulateCoachResponse(text);
      final coachMessage = {
        'sender': 'coach',
        'text': responseText,
        'time': AppText.timeJustNow,
      };

      await _aiRepository.addMessage(coachMessage);
      _messages.add(coachMessage);
      _isTyping = false;
      notifyListeners();

      onResponseReceived();
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
