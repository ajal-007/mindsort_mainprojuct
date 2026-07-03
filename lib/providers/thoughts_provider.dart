import 'package:flutter/material.dart';
import '../core/constants/app_text.dart';
import '../repositories/thoughts_repository.dart';

class ThoughtsProvider extends ChangeNotifier {
  final ThoughtsRepository _thoughtsRepository = ThoughtsRepository();

  List<Map<String, String>> _thoughts = [];
  List<Map<String, String>> get thoughts => _thoughts;

  List<Map<String, String>> _filteredThoughts = [];
  List<Map<String, String>> get filteredThoughts => _filteredThoughts;

  String _selectedCategory = AppText.catAll;
  String get selectedCategory => _selectedCategory;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ThoughtsProvider() {
    loadThoughts();
  }

  Future<void> loadThoughts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _thoughts = await _thoughtsRepository.fetchThoughts();
      _filterThoughts();
    } catch (_) {
      // Silent error handler for simulation
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    _filterThoughts();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterThoughts();
    notifyListeners();
  }

  void _filterThoughts() {
    final query = _searchQuery.toLowerCase();
    _filteredThoughts = _thoughts.where((thought) {
      final matchesSearch = thought['title']!.toLowerCase().contains(query) ||
          thought['content']!.toLowerCase().contains(query);
      final matchesCategory =
          _selectedCategory == AppText.catAll || thought['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  Future<void> addThought({
    required String title,
    required String category,
    required String content,
  }) async {
    if (title.isEmpty || content.isEmpty) return;

    String hexColor = '0xFF6C63FF';
    if (category == AppText.catIdeas) hexColor = '0xFF6C63FF';
    if (category == AppText.catTasks) hexColor = '0xFF5EA8FF';
    if (category == AppText.catReflections) hexColor = '0xFF9D97FF';
    if (category == AppText.catDreams) hexColor = '0xFFFF7597';

    final newThought = {
      'title': title,
      'category': category,
      'time': AppText.timeJustNow,
      'content': content,
      'color': hexColor,
    };

    await _thoughtsRepository.addThought(newThought);
    _thoughts.insert(0, newThought);
    _filterThoughts();
    notifyListeners();
  }
}
