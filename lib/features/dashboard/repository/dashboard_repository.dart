import 'package:mainsupabase_projuct/features/dashboard/models/dashboardata.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class DashboardRepository {
  final _supabase = Supabase.instance.client;

  Future<DashboardData> getDashboard() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in.');
    }

    final response = await _supabase
        .from('assessment_results')
        .select()
        .eq('user_id', user.id)
        .order('assessment_number', ascending: false)
        .limit(1)
        .single();

    return DashboardData.fromJson(response);
  }

  
}