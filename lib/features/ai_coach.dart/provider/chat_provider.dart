import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/models/chat_message_model.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/models/chat_request_model.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/models/chat_session_model.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/repository/chat_repository.dart';


class ChatProvider extends ChangeNotifier {
  final ChatRepository _repository;

  ChatProvider({
    ChatRepository? repository,
  }) : _repository = repository ?? ChatRepository();

  List<ChatSessionModel> _sessions = [];
  List<ChatMessageModel> _messages = [];

  ChatSessionModel? _currentSession;

  bool _isLoading = false;
  bool _isSending = false;

  String? _error;

  List<ChatSessionModel> get sessions => _sessions;
  List<ChatMessageModel> get messages => _messages;

  ChatSessionModel? get currentSession => _currentSession;

  bool get isLoading => _isLoading;
  bool get isSending => _isSending;

  String? get error => _error;

  Future<void> loadSessions() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _sessions = await _repository.getSessions();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

Future<void> createSession() async {
  try {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final session = await _repository.createSession();

    _sessions.insert(0, session);

    _currentSession = session;
    _messages = [];
  } catch (e) {
    _error = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<void> loadMessages(
    String sessionId,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      _messages = await _repository.getMessages(sessionId);

      _currentSession = _sessions.firstWhere(
        (session) => session.id == sessionId,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

Future<void> sendMessage(String message) async {
  if (_currentSession == null || message.trim().isEmpty) {
    return;
  }

  final optimisticMessage = ChatMessageModel(
    id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
    sessionId: _currentSession!.id,
    role: 'user',
    content: message,
    createdAt: DateTime.now(),
  );

  try {
    _isSending = true;
    _error = null;

    // Show the user's message immediately
    _messages.add(optimisticMessage);
    notifyListeners();

    final response = await _repository.sendMessage(
      ChatRequestModel(
        sessionId: _currentSession!.id,
        message: message,
      ),
    );

    if (!response.success) {
      _error = response.error;
      _messages.removeWhere((msg) => msg.id == optimisticMessage.id);
      return;
    }

    // Update the session title if AI generated one
    if (response.title != null &&
        response.title!.isNotEmpty &&
        _currentSession!.title != response.title) {
      _currentSession = _currentSession!.copyWith(
        title: response.title,
      );

      final index = _sessions.indexWhere(
        (session) => session.id == _currentSession!.id,
      );

      if (index != -1) {
        _sessions[index] = _currentSession!;
      }
    }

    // Reload messages so IDs and timestamps stay in sync
    _messages = await _repository.getMessages(
      _currentSession!.id,
    );
  } catch (e) {
    _error = e.toString();
    _messages.removeWhere((msg) => msg.id == optimisticMessage.id);
  } finally {
    _isSending = false;
    notifyListeners();
  }
}

  Future<void> deleteSession(
    String sessionId,
  ) async {
    try {
      await _repository.deleteSession(sessionId);

      _sessions.removeWhere(
        (session) => session.id == sessionId,
      );

      if (_currentSession?.id == sessionId) {
        _currentSession = null;
        _messages.clear();
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> selectSession(String sessionId) async {
  try {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _currentSession = _sessions.firstWhere(
      (session) => session.id == sessionId,
    );

    _messages = await _repository.getMessages(sessionId);
  } catch (e) {
    _error = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

Future<void> initialize() async {
  try {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _sessions = await _repository.getSessions();

    if (_sessions.isEmpty) {
      final session = await _repository.createSession();

      _sessions.add(session);

      _currentSession = session;
      _messages = [];
    } else {
      _currentSession = _sessions.first;

      _messages = await _repository.getMessages(
        _currentSession!.id,
      );
    }
  } catch (e) {
    _error = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
}