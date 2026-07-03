import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/app_api.dart';
import '../core/constants/app_keys.dart';

class ProfileService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    return await supabase
        .from(AppApi.profilesTable)
        .select()
        .eq(AppKeys.profileId, userId)
        .maybeSingle();
  }
}
