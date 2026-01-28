enum UserRole {
  admin,
  petugas,
  peminjam,
}

enum PeminjamanStatus {
  pengajuan,
  dipinjam,
  dikembalikan,
  selesai,
  ditolak,
}

enum CardMode {
  admin,
  petugas,
  peminjam,
}

// extension label 
extension PeminjamanStatusLabel on PeminjamanStatus {
  String get label {
    switch (this) {
      case PeminjamanStatus.pengajuan: return "Pengajuan";
      case PeminjamanStatus.dipinjam: return "Dipinjam";
      case PeminjamanStatus.dikembalikan: return "Dikembalikan";
      case PeminjamanStatus.selesai: return "Selesai";
      case PeminjamanStatus.ditolak: return "Ditolak";
    }
  }
}


//alat pinjam
enum AlatCardVariant {
  list,
  popup,
}
