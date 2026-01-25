import 'package:supabase_flutter/supabase_flutter.dart';

class KategoriService {
  final SupabaseClient supabase;

  KategoriService(this.supabase);

  // Ambil 
  Future<List<Map<String, dynamic>>> getKategori() async {
    try {
      final data = await supabase.from('kategori').select();
      return List<Map<String, dynamic>>.from(data as List);
    } catch (e) {
      throw Exception('Gagal load kategori: $e');
    }
  }

  // Tambah 
  Future<void> addKategori({required String namaKategori}) async {
    try {
      await supabase.from('kategori').insert({
        'nama_kategori': namaKategori,
      });
    } catch (e) {
      throw Exception('Gagal menambahkan kategori: $e');
    }
  }

  // Update 
  Future<void> updateKategori({
    required int idKategori,
    required String namaKategori,
  }) async {
    try {
      await supabase.from('kategori').update({
        'nama_kategori': namaKategori,
      }).eq('id_kategori', idKategori);
    } catch (e) {
      throw Exception('Gagal update kategori: $e');
    }
  }

  // Hapus 
  Future<void> deleteKategori(int idKategori) async {
    try {
      await supabase.from('kategori').delete().eq('id_kategori', idKategori);
    } catch (e) {
      throw Exception('Gagal menghapus kategori: $e');
    }
  }
}
