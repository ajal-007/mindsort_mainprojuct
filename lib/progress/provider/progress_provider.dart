import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/progress/models/progress_point_model.dart';
import 'package:mainsupabase_projuct/progress/repository/progress_repository.dart';



class ProgressProvider extends ChangeNotifier {
  final ProgressRepository _repository;

  ProgressProvider({
    ProgressRepository? repository,
  }) : _repository = repository ?? ProgressRepository();

  List<ProgressPoint> _progress = [];

  List<ProgressPoint> get progress => _progress;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  Future<void> loadProgress() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _progress = await _repository.fetchProgressHistory();

      developer.log(
        'Loaded ${_progress.length} progress points.',
        name: 'ProgressProvider',
      );
    } catch (e, stackTrace) {
      _error = e.toString();

      developer.log(
        'Failed to load progress.',
        name: 'ProgressProvider',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}