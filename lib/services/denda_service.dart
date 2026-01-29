import 'package:supabase_flutter/supabase_flutter.dart';

class DendaService {
  final SupabaseClient supabase;

  DendaService(this.supabase);

  // Ambil semua denda
  Future<List<Map<String, dynamic>>> getDenda() async {
    try {
      final data = await supabase
          .from('denda')
          .select()
          .order('id_denda'); 
      return List<Map<String, dynamic>>.from(data as List);
    } catch (e) {
      throw Exception('Gagal load denda: $e');
    }
  }

  // Tambah denda
  Future<void> addDenda({required String jenisDenda, required double tarif}) async {
    try {
      await supabase.from('denda').insert({
        'jenis_denda': jenisDenda,
        'tarif': tarif,
      });
    } catch (e) {
      throw Exception('Gagal menambahkan denda: $e');
    }
  }

  // Update denda
  Future<void> updateDenda({
    required int idDenda,
    required String jenisDenda,
    required double tarif,
  }) async {
    try {
      await supabase
          .from('denda')
          .update({'jenis_denda': jenisDenda, 'tarif': tarif})
          .eq('id_denda', idDenda);
    } catch (e) {
      throw Exception('Gagal update denda: $e');
    }
  }

  // Hapus denda
  Future<void> deleteDenda(int idDenda) async {
    try {
      await supabase.from('denda').delete().eq('id_denda', idDenda);
    } catch (e) {
      throw Exception('Gagal menghapus denda: $e');
    }
  }
}
