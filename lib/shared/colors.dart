import 'package:flutter/material.dart';
import 'enums.dart'; 

class AppColors {
  static const pengajuan = Color(0xFFF4950A);
  static const dipinjam = Color(0xFF1155A2);
  static const selesai = Color(0xFF48BDAE);
  static const ditolak = Color(0xFFFF0000);
  static const dikembalikan = Color(0xFF671E36);

  static const strokeCard = Color(0xFF8294C4);
  static const greyText = Color(0xFF5E5E5E);
}

// extension warna
extension PeminjamanStatusColor on PeminjamanStatus {
  Color get color {
    switch (this) {
      case PeminjamanStatus.pengajuan: return AppColors.pengajuan;
      case PeminjamanStatus.dipinjam: return AppColors.dipinjam;
      case PeminjamanStatus.dikembalikan: return AppColors.dikembalikan;
      case PeminjamanStatus.selesai: return AppColors.selesai;
      case PeminjamanStatus.ditolak: return AppColors.ditolak;
    }
  }
}
