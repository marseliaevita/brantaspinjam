import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

/// Ajukan 
Future<bool> ajukanPeminjaman({
  required int idAlat,
  required DateTime tanggalPinjam,
  required DateTime tanggalKembali,
}) async {
  try {
    final user = supabase.auth.currentUser;
    if (user == null) return false;

    await supabase.from('peminjaman').insert({
      'user_id': user.id,
      'id_alat': idAlat,
      'tanggal_pinjam': tanggalPinjam.toIso8601String(),
      'tanggal_kembali': tanggalKembali.toIso8601String(),
      'status_peminjaman': 'pengajuan', 
    });

    return true;
  } catch (e) {
    print('Error ajukan peminjaman: $e');
    return false;
  }
}

//pengembalian
Future<bool> ajukanPengembalian({
  required int idPeminjaman,
  required DateTime tanggalDikembalikan,
}) async {
  try {
    final existing = await supabase
        .from('pengembalian')
        .select('id_pengembalian')
        .eq('id_peminjaman', idPeminjaman)
        .maybeSingle(); 

    if (existing != null) {
      await supabase.from('pengembalian').update({
        'tanggal_dikembalikan': tanggalDikembalikan.toIso8601String(),
        'terlambat': false,
      }).eq('id_peminjaman', idPeminjaman);
    } else {
     
      await supabase.from('pengembalian').insert({
        'id_peminjaman': idPeminjaman,
        'tanggal_dikembalikan': tanggalDikembalikan.toIso8601String(),
        'terlambat': false,
      });
    }

    await supabase.from('peminjaman').update({
      'status_peminjaman': 'dikembalikan',
    }).eq('id_peminjaman', idPeminjaman);

    return true;
  } catch (e) {
    print('Error ajukan pengembalian: $e');
    return false;
  }
}
