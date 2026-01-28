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


  /// UI VISIBILITY RULE
  bool get showTanggalDikembalikan =>
      isDikembalikan || isSelesai;

  bool get showKondisi => isSelesai;

  bool get showDenda => isSelesai;
 

  /// VALIDATION RULE
  bool get isTanggalDikembalikanValid {
    if (!showTanggalDikembalikan) return true;
    return tanggalDikembalikan != null;
  }

  bool get isDendaValid {
    if (!showDenda) return true;
    return (dendaTerlambatHari ?? 0) >= 0;
  }

 
  /// MAPPING DB
  factory PeminjamanModel.fromMap(Map<String, dynamic> map) {
    return PeminjamanModel(
      nama: map['nama'],
      alat: map['alat'],
      tanggalPinjam: DateTime.parse(map['tanggal_pinjam']),
      tanggalBatas: DateTime.parse(map['tanggal_batas']),
      tanggalDikembalikan: map['tanggal_dikembalikan'] != null
          ? DateTime.parse(map['tanggal_dikembalikan'])
          : null,
      status: PeminjamanStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => PeminjamanStatus.pengajuan,
      ),
      kondisi: map['kondisi'],
      dendaTerlambatHari: map['denda_terlambat'],
      dendaKerusakan: map['denda_kerusakan'] != null
          ? List<String>.from(map['denda_kerusakan'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'alat': alat,
      'tanggal_pinjam': tanggalPinjam.toIso8601String(),
      'tanggal_batas': tanggalBatas.toIso8601String(),
      'tanggal_dikembalikan': tanggalDikembalikan?.toIso8601String(),
      'status': status.name,
      'kondisi': kondisi,
      'denda_terlambat': dendaTerlambatHari,
      'denda_kerusakan': dendaKerusakan,
    };
  }
}
