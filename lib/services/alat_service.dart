import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class AlatService {
  final SupabaseClient supabase;

  AlatService(this.supabase);

  // Ambil 
  Future<List<Map<String, dynamic>>> getAlat({int? idKategori}) async {
    try {
      var query = supabase.from('alat').select();
      
      if (idKategori != null) {
        query = query.eq('id_kategori', idKategori);
      }

      final data = await query; 
      return List<Map<String, dynamic>>.from(data as List);
    } catch (e) {
      throw Exception('Gagal mengambil alat: $e');
    }
  }

  
  Future<String> uploadGambar(Uint8List bytes, String fileName) async {
    try {
      final bucket = supabase.storage.from('alat');
      await bucket.uploadBinary(
        fileName,
        bytes,
        fileOptions: const FileOptions(upsert: true),
      );

      
      final url = bucket.getPublicUrl(fileName);
      return url;
    } catch (e) {
      throw Exception('Gagal upload gambar: $e');
    }
  }

  // Tambah alat admin
  Future<void> addAlat({
    required String nama,
    required int idKategori,
    required String status,
    required int stok,
    String? gambarUrl,
  }) async {
    try {
      await supabase.from('alat').insert({
        'nama_alat': nama,
        'id_kategori': idKategori,
        'status': status,
        'stok': stok,
        'gambar': gambarUrl,
      });
    } catch (e) {
      throw Exception('Gagal menambahkan alat: $e');
    }
  }

  // Update alat
  Future<void> updateAlat({
    required int idAlat,
    required String nama,
    required int idKategori,
    required String status,
    required int stok,
    String? gambarUrl,
  }) async {
    try {
      await supabase.from('alat').update({
        'nama_alat': nama,
        'id_kategori': idKategori,
        'status': status,
        'stok': stok,
        'gambar': gambarUrl,
      }).eq('id_alat', idAlat);
    } catch (e) {
      throw Exception('Gagal update alat: $e');
    }
  }

  // Hapus alat
 Future<void> deleteAlat({
  required int idAlat,
  String? gambarUrl,
}) async {
  try {
    if (gambarUrl != null && gambarUrl.isNotEmpty) {
      final uri = Uri.parse(gambarUrl);
      final path = uri.pathSegments.last;

      await supabase.storage.from('alat').remove([path]);
    }

    await supabase.from('alat').delete().eq('id_alat', idAlat);
  } catch (e) {
    throw Exception('Gagal menghapus alat: $e');
  }
}

Future<bool> isAlatDipakai(int idAlat) async {
  final data = await supabase
      .from('peminjaman')
      .select('id_peminjaman')
      .eq('id_alat', idAlat)
      .limit(1);

  return (data as List).isNotEmpty;
}


}
