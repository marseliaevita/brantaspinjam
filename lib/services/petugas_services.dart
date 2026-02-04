import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

/// Setujui peminjaman
Future<bool> approvePeminjaman(int idPeminjaman) async {
  try {
    final user = supabase.auth.currentUser;
    if (user == null) return false;

    final res = await supabase.from('peminjaman').update({
      'status_peminjaman': 'dipinjam',
      'disetujui_oleh': user.id,
    }).eq('id_peminjaman', idPeminjaman);

    print('Approve Result: $res');
    return true;
  } catch (e) {
    print('Error Approve: $e');
    return false;
  }
}

/// Tolak peminjaman
Future<bool> rejectPeminjaman(int idPeminjaman) async {
  try {
    final user = supabase.auth.currentUser;
    if (user == null) return false;

    final res = await supabase.from('peminjaman').update({
      'status_peminjaman': 'ditolak',
      'disetujui_oleh': user.id,
    }).eq('id_peminjaman', idPeminjaman);

    print('Reject Result: $res');
    return true;
  } catch (e) {
    print('Error Reject: $e');
    return false;
  }
}

/// Cek pengembalian
Future<bool> cekPengembalian({
  required int idPeminjaman,
  required String kondisi,
  required int tarifTerlambat,
  int terlambatHari = 0,
  int dendaKerusakan = 0,
  int? idDenda,
}) async {
  try {
    final tanggalSekarang = DateTime.now();

    const int tarifTerlambatPerHari = 5000;
    final totalDenda = (terlambatHari * tarifTerlambatPerHari) + dendaKerusakan;

    await supabase.from('pengembalian').upsert({
      'id_peminjaman': idPeminjaman,
      'tanggal_dikembalikan': tanggalSekarang.toIso8601String(),
      'kondisi_alat': kondisi,
      'terlambat': terlambatHari > 0,
      'total_denda': totalDenda,
      'id_denda': idDenda,
    }, onConflict: 'id_peminjaman');

    await supabase.from('peminjaman').update({
      'status_peminjaman': 'selesai',
    }).eq('id_peminjaman', idPeminjaman);

    return true;
  } catch (e) {
    print('Error cekPengembalian: $e');
    return false;
  }
}
