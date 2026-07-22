
import 'package:mainsupabase_projuct/progress/models/progress_point_model.dart';
import 'package:mainsupabase_projuct/progress/service/progress_service.dart';

class ProgressRepository {
  final ProgressService _progressService;

  ProgressRepository({
    ProgressService? progressService,
  }) : _progressService = progressService ?? ProgressService();

  Future<List<ProgressPoint>> fetchProgressHistory() async {
    return await _progressService.fetchProgressHistory();
  }
}