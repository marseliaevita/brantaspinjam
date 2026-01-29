import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brantaspinjam/model/model_peminjaman.dart';

final supabase = Supabase.instance.client;

/// Ambil 
Future<List<PeminjamanModel>> fetchPeminjamanAdminDummy() async {
  try {
    final rawData = await supabase
        .from('peminjaman')
        .select('*')
        .order('tanggal_pinjam', ascending: false);

    if (rawData == null || rawData is! List) return [];

    // mapping ke model 
    return rawData.map((e) => PeminjamanModel.fromMap(e)).toList();
  } catch (e, st) {
    print('Supabase query error: $e\n$st');
    return [];
  }
}
