import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brantaspinjam/services/supabase_config.dart';

class DashboardService {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<Map<String, String>> getStats(String role, String userId) async {
    try {
      if (role == 'admin') {
        final alat = await _client.from('alat').count(CountOption.exact);
        final users = await _client.from('users').count(CountOption.exact);
        final kategori = await _client.from('kategori').count(CountOption.exact);
        final pinjam = await _client.from('peminjaman').count(CountOption.exact);

        return {
          'alat': alat.toString(),
          'users': users.toString(),
          'kategori': kategori.toString(),
          'pinjam': pinjam.toString(),
        };
      } 
      
      if (role == 'petugas') {
        final pengajuan = await _client.from('peminjaman').count(CountOption.exact).eq('status_peminjaman', 'diajukan');
        final dipinjam = await _client.from('peminjaman').count(CountOption.exact).eq('status_peminjaman', 'disetujui');
        final kembali = await _client.from('pengembalian').count(CountOption.exact);
        final terlambat = await _client.from('peminjaman').count(CountOption.exact)
            .eq('status_peminjaman', 'disetujui')
            .lt('tanggal_kembali', DateTime.now().toIso8601String());

        return {
          'pengajuan': pengajuan.toString(),
          'dipinjam': dipinjam.toString(),
          'kembali': kembali.toString(),
          'terlambat': terlambat.toString(),
        };
      }

      // Role Peminjam
      final pengajuan = await _client.from('peminjaman').count(CountOption.exact).eq('user_id', userId).eq('status_peminjaman', 'diajukan');
      final dipinjam = await _client.from('peminjaman').count(CountOption.exact).eq('user_id', userId).eq('status_peminjaman', 'disetujui');
      final terlambat = await _client.from('peminjaman').count(CountOption.exact)
          .eq('user_id', userId)
          .eq('status_peminjaman', 'disetujui')
          .lt('tanggal_kembali', DateTime.now().toIso8601String());
      final selesai = await _client.from('peminjaman').count(CountOption.exact).eq('user_id', userId).eq('status_peminjaman', 'kembali');

      return {
        'pengajuan': pengajuan.toString(),
        'dipinjam': dipinjam.toString(),
        'terlambat': terlambat.toString(),
        'selesai': selesai.toString(),
      };
    } catch (e) {
      print("Error Stats: $e");
      return {};
    }
  }

  
Future<List<Map<String, dynamic>>> getMyLoans(String userId) async {
  try {
    final res = await _client
        .from('peminjaman')
        .select('''
          id_peminjaman,
          tanggal_pinjam,
          status_peminjaman,
          alat ( nama_alat )
        ''')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(5); 
    return List<Map<String, dynamic>>.from(res);
  } catch (e) {
    print("Error getMyLoans: $e");
    return [];
  }
}
}