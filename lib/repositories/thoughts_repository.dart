import '../services/thoughts_service.dart';

class ThoughtsRepository {
  final ThoughtsService _thoughtsService = ThoughtsService();

  Future<List<Map<String, String>>> fetchThoughts() async {
    return await _thoughtsService.fetchThoughts();
  }

  Future<void> addThought(Map<String, String> thought) async {
    await _thoughtsService.addThought(thought);
  }
}
