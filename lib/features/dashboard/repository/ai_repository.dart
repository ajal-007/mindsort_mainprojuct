

import 'package:mainsupabase_projuct/features/dashboard/models/ai_insightmodel.dart';
import 'package:mainsupabase_projuct/features/dashboard/models/dashboardata.dart';
import 'package:mainsupabase_projuct/features/dashboard/services/ai_data.dart';

class AIRepository {
  final AiDashboardService _service = AiDashboardService();

  Future<AIInsight> generateInsight(
    DashboardData dashboard,
  ) async {
    return await _service.generateInsight(dashboard);
  }
}