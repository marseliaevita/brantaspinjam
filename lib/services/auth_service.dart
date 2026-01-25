import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brantaspinjam/services/supabase_config.dart';

class AuthService {
  final SupabaseClient _client = SupabaseConfig.client;

  // Login 
  Future<User?> signIn(String email, String password) async {
    try {
      final session = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return session.user;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Login gagal: $e");
    }
  }

  // Logout
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Get current user
  User? get currentUser => _client.auth.currentUser;
}
