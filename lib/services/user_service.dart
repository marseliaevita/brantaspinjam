import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brantaspinjam/services/supabase_config.dart';
import 'package:brantaspinjam/shared/enums.dart';

class UserService {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<UserRole> getMyRole() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login');
    }

    final res = await _client
    .from('users')
    .select('user_id, role')
    .eq('user_id', user.id)
    .single();

    print('USER ROLE RESULT: $res');
    print('AUTH UID: ${user.id}');


    final roleString = res['role'] as String;

    switch (roleString) {
      case 'admin':
        return UserRole.admin;
      case 'petugas':
        return UserRole.petugas;
      default:
        return UserRole.peminjam;
    }
  }
}
