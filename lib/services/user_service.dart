import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brantaspinjam/services/supabase_config.dart';
import 'package:brantaspinjam/shared/enums.dart';

class UserService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// ROLE USER LOGIN
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

  /// AMBIL SEMUA USER (
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login');
    }

    final res = await _client
        .from('users')
        .select('user_id, name, email, role, is_active, created_at')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }

  /// AKTIFKAN USER
  Future<void> activateUser(String userId) async {
    await _client
        .from('users')
        .update({'is_active': true})
        .eq('user_id', userId);
  }

  /// NONAKTIFKAN USER
  Future<void> deactivateUser(String userId) async {
    await _client
        .from('users')
        .update({'is_active': false})
        .eq('user_id', userId);
  }

  /// CREATE USER (ADMIN)
/// CREATE USER (ADMIN)
  Future<void> createUser({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      final response = await _client.functions.invoke(
        'smooth-service',
        method: HttpMethod.post,
        body: {
          'email': email,
          'password': password,
          'name': name,
          'role': role,
        },
      );

      if (response.status != 200) {
        final errorMsg = response.data?['error'] ?? 'Gagal membuat user';
        throw Exception(errorMsg);
      }
      
      print("Berhasil: ${response.data}");
    } catch (e) {
      print("Error di createUser: $e");
      rethrow;
    }
  }

/// UPDATE USER
Future<void> updateUser(
  String userId,
  String name,
  String role,
) async {
  await _client
      .from('users')
      .update({
        'name': name,
        'role': role,
      })
      .eq('user_id', userId);
}
  
}
