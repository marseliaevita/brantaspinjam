import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brantaspinjam/model/model_user.dart';

class UserSessionService {
  final _client = Supabase.instance.client;

  /// ambil data user login dari tabel users
  Future<UserModel> getCurrentUser() async {
    final authUser = _client.auth.currentUser;
    if (authUser == null) {
      throw Exception('User belum login');
    }

    final res = await _client
        .from('users')
        .select()
        .eq('user_id', authUser.id)
        .single();

    return UserModel.fromJson(res);
  }

  /// cek role user login
  Future<String> getRole() async {
    final user = await getCurrentUser();
    return user.role;
  }

  
}
