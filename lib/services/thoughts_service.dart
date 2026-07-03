import '../../core/constants/app_text.dart';

class ThoughtsService {
  final List<Map<String, String>> _thoughts = [
    {
      'title': 'Cerebral Database Architecture',
      'category': AppText.catIdeas,
      'time': '10 min ago',
      'content': 'We need a multi-tenant layout mapped with standard partition keys inside Supabase table metadata.',
      'color': '0xFF6C63FF',
    },
    {
      'title': 'Weekly Action Items',
      'category': AppText.catTasks,
      'time': '2 hours ago',
      'content': 'Finish refactoring the theme layout configurations, configure MultiProvider binding rules.',
      'color': '0xFF5EA8FF',
    },
    {
      'title': 'Reflective Journaling Session',
      'category': AppText.catReflections,
      'time': '1 day ago',
      'content': 'Focusing on incremental milestones reduces anxiety and helps track daily progress metrics.',
      'color': '0xFF9D97FF',
    },
  ];

  Future<List<Map<String, String>>> fetchThoughts() async {
    return List.from(_thoughts);
  }

  Future<void> addThought(Map<String, String> thought) async {
    _thoughts.insert(0, thought);
  }
}
