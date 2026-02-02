import 'package:flutter/material.dart';
import 'package:brantaspinjam/widgets/card_popup.dart';
import 'package:brantaspinjam/services/peminjam_services.dart';
import 'package:brantaspinjam/model/model_peminjaman.dart';

class PengembalianPopup extends StatelessWidget {
  final PeminjamanModel data;
  final VoidCallback? onRefresh;

  const PengembalianPopup({
    super.key,
    required this.data,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return CardPopup(
      title: "Pengembalian",
      width: 350,
      height: 232,
      submitText: "Ya",
      onCancel: () => Navigator.pop(context),
      onSubmit: () async {
        final now = DateTime.now();

        
        final success = await ajukanPengembalian(
          idPeminjaman: data.idPeminjaman!,
          tanggalDikembalikan: now,
        );

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Pengembalian berhasil diajukan'
                : 'Gagal mengajukan pengembalian'),
          ),
        );

        onRefresh?.call();
      },
      content: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          "Anda akan mengembalikan pinjaman ini?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF0E0A26),
          ),
        ),
      ),
    );
  }
}
