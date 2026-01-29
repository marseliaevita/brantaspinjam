import 'dart:convert';
import 'package:brantaspinjam/shared/enums.dart';

class PeminjamanModel {
  final String nama;
  final String alat;

  final DateTime tanggalPinjam;
  final DateTime tanggalBatas;
  final DateTime? tanggalDikembalikan;

  final PeminjamanStatus status;

  final String? kondisi;
  final int? dendaTerlambatHari;
  final List<String>? dendaKerusakan;

  PeminjamanModel({
    required this.nama,
    required this.alat,
    required this.tanggalPinjam,
    required this.tanggalBatas,
    this.tanggalDikembalikan,
    required this.status,
    this.kondisi,
    this.dendaTerlambatHari,
    this.dendaKerusakan,
  });

  /// STATUS CHECK
  bool get isPengajuan => status == PeminjamanStatus.pengajuan;
  bool get isDipinjam => status == PeminjamanStatus.dipinjam;
  bool get isDikembalikan => status == PeminjamanStatus.dikembalikan;
  bool get isSelesai => status == PeminjamanStatus.selesai;
  bool get isDitolak => status == PeminjamanStatus.ditolak;

  bool get showTanggalDikembalikan => isDikembalikan || isSelesai;
  bool get showKondisi => isSelesai;
  bool get showDenda => isSelesai;

  /// DUMMY MAPPING
  factory PeminjamanModel.fromMap(Map<String, dynamic> map) {
    return PeminjamanModel(
      nama: "User ${map['user_id'].toString().substring(0,5)}",
      alat: "Alat ${map['id_alat']}",
      tanggalPinjam: DateTime.parse(map['tanggal_pinjam']),
      tanggalBatas: DateTime.parse(map['tanggal_kembali']),
      tanggalDikembalikan: null,
      status: PeminjamanStatus.values.firstWhere(
        (e) => e.name == map['status_peminjaman'],
        orElse: () => PeminjamanStatus.pengajuan,
      ),
      kondisi: "Baik",
      dendaTerlambatHari: 0,
      dendaKerusakan: [],
    );
  }

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
      'denda_kerusakan':
          dendaKerusakan != null ? jsonEncode(dendaKerusakan) : null,
    };
  }
}
