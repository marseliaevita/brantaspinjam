import 'dart:convert';
import 'package:brantaspinjam/shared/enums.dart';

class PeminjamanModel {
  final int? idPeminjaman;
  final String nama;
  final String alat;

  final String userId;
  final int idAlat;
  final int? idDenda;
  
  final DateTime tanggalPinjam;
  final DateTime tanggalBatas;
  final DateTime? tanggalDikembalikan;

  final PeminjamanStatus status;

  final String? kondisi;
  final int? dendaTerlambatHari;
  final List<int>? dendaKerusakan;

  PeminjamanModel({
    required this.idPeminjaman,
    required this.nama,
    required this.alat,
    required this.userId,
    required this.idAlat,
    this.idDenda,
    required this.tanggalPinjam,
    required this.tanggalBatas,
    this.tanggalDikembalikan,
    required this.status,
    this.kondisi,
    this.dendaTerlambatHari,
    this.dendaKerusakan,
     
  });

   int get totalDenda {
    final terlambat = dendaTerlambatHari ?? 0;
    final rusak = dendaKerusakan?.fold(0, (sum, e) => sum + e) ?? 0;
    return terlambat + rusak;
  }

  /// STATUS CHECK
  bool get isPengajuan => status == PeminjamanStatus.pengajuan;
  bool get isDipinjam => status == PeminjamanStatus.dipinjam;
  bool get isDikembalikan => status == PeminjamanStatus.dikembalikan;
  bool get isSelesai => status == PeminjamanStatus.selesai;
  bool get isDitolak => status == PeminjamanStatus.ditolak;

  bool get showTanggalDikembalikan => isDikembalikan || isSelesai;
  bool get showKondisi => isSelesai;
  bool get showDenda => isSelesai;

  factory PeminjamanModel.fromMap(
    Map<String, dynamic> map, {
    Map<String, dynamic>? extraData,
  }) {
    return PeminjamanModel(
      idPeminjaman: map['id_peminjaman'],
      nama: map['peminjam']?['name'] ?? "User",
      alat: map['alat']?['nama_alat'] ?? "Alat",
      userId: map['user_id'],
      idAlat: map['id_alat'],
      idDenda: extraData != null ? extraData['id_denda'] as int? : null,

      tanggalPinjam: DateTime.parse(map['tanggal_pinjam']),
      tanggalBatas: DateTime.parse(map['tanggal_kembali']),

      tanggalDikembalikan: extraData?['tanggal_dikembalikan'] != null
          ? DateTime.parse(extraData!['tanggal_dikembalikan'])
          : null,

      status: PeminjamanStatus.values.firstWhere(
        (e) => e.name == map['status_peminjaman'],
        orElse: () => PeminjamanStatus.pengajuan,
      ),

      kondisi: extraData?['kondisi_alat'],
      dendaTerlambatHari: extraData?['total_denda']?.toInt() ?? 0,
     dendaKerusakan: extraData?['denda_kerusakan'] != null
    ? List<int>.from((jsonDecode(extraData!['denda_kerusakan']) as List<dynamic>))
    : [],

    );
  }

  /// MAPPING
  Map<String, dynamic> toMapForDB({
    required String userId,
    required int alatId,
  }) {
    return {
      'user_id': userId,
      'id_alat': alatId,
      'tanggal_pinjam': tanggalPinjam.toIso8601String(),
      'tanggal_kembali': tanggalBatas.toIso8601String(),
      'tanggal_dikembalikan': tanggalDikembalikan?.toIso8601String(),
      'status_peminjaman': status.name,
      'kondisi': kondisi,
      'denda_terlambat': dendaTerlambatHari,
      'denda_kerusakan': dendaKerusakan != null
          ? jsonEncode(dendaKerusakan)
          : null,
    };
  }
}
