import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brantaspinjam/model/model_peminjaman.dart';

final supabase = Supabase.instance.client;

/// ambil 
Future<List<PeminjamanModel>> fetchPeminjamanAdmin() async {
  try {
    final rawData = await supabase
        .from('peminjaman')
        .select('''
          *,
          peminjam:user_id ( name ),
          alat:id_alat ( nama_alat ),
          pengembalian (
            tanggal_dikembalikan,
            kondisi_alat,
            total_denda,
            id_denda
          )
        ''') 
        .order('tanggal_pinjam', ascending: false);

    return (rawData as List).map((e) {
  final pengembalian =
      e['pengembalian'] is Map<String, dynamic>
          ? e['pengembalian']
          : null;

  return PeminjamanModel.fromMap(e, extraData: pengembalian);
}).toList();

  } catch (e) {
    print('Error: $e');
    return [];
  }
}

//pengembalian
Future<List<PeminjamanModel>> fetchPengembalianAdmin() async {
  try {
    final rawData = await supabase
        .from('peminjaman')
        .select('''
          *,
          peminjam:user_id ( name ),
          alat:id_alat ( nama_alat ),
          pengembalian (
            tanggal_dikembalikan,
            kondisi_alat,
            total_denda,
            id_denda
          )
        ''')
        .inFilter('status_peminjaman', ['dikembalikan', 'selesai']) 
        .order('tanggal_pinjam', ascending: false);

    return (rawData as List).map((e) {
  final pengembalian =
      e['pengembalian'] is Map<String, dynamic>
          ? e['pengembalian']
          : null;

  return PeminjamanModel.fromMap(e, extraData: pengembalian);
}).toList();

  } catch (e) {
    print('Error Fetching Pengembalian: $e');
    return [];
  }
}

//list peminjaman role=peminjam
Future<List<PeminjamanModel>> fetchPeminjamanUser() async {
  try {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final rawData = await supabase
        .from('peminjaman')
        .select('''
          *,
          peminjam:user_id ( name ),
          alat:id_alat ( nama_alat ),
          pengembalian (
            tanggal_dikembalikan,
            kondisi_alat,
            total_denda,
            id_denda
          )
        ''')
        .eq('user_id', user.id) 
        .order('tanggal_pinjam', ascending: false);

    return (rawData as List).map((e) {
  final pengembalian =
      e['pengembalian'] is Map<String, dynamic>
          ? e['pengembalian']
          : null;

  return PeminjamanModel.fromMap(e, extraData: pengembalian);
}).toList();

  } catch (e) {
    print('Error Fetching User Peminjaman: $e');
    return [];
  }
}

//delete--trouble
Future<void> deletePeminjaman(int idPeminjaman) async {
  final supabase = Supabase.instance.client;

  print('DELETE SERVICE ID: $idPeminjaman');

  await supabase
      .from('pengembalian')
      .delete()
      .eq('id_peminjaman', idPeminjaman);

  final res = await supabase
      .from('peminjaman')
      .delete()
      .eq('id_peminjaman', idPeminjaman)
      .select();

  print('DELETE RESULT: $res');
}





//denda
Future<Map<String, dynamic>> fetchSettingDenda() async {
  try {
    final data = await supabase.from('denda').select();
    final List list = data as List;

    final itemTerlambat = list.firstWhere(
      (e) => e['jenis_denda'].toString().toLowerCase().contains('terlambat'),
      orElse: () => {'tarif': 5000},
    );

    final listKerusakan = list.where(
      (e) => !e['jenis_denda'].toString().toLowerCase().contains('terlambat')
    ).toList();

    return {
      'tarifTerlambat': (itemTerlambat['tarif'] as num).toInt(),
      'listKerusakan': List<Map<String, dynamic>>.from(listKerusakan),
    };
  } catch (e) {
    return {'tarifTerlambat': 5000, 'listKerusakan': []};
  }
}