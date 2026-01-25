import 'package:flutter/material.dart';
import 'package:brantaspinjam/widgets/card_popup.dart';
import 'package:brantaspinjam/screen/admin/alat/alat_add_edit.dart';

class AlatCard extends StatelessWidget {
  final String nama;
  final String kategori;
  final int stok;
  final String gambar;

  const AlatCard({
    super.key,
    required this.nama,
    required this.kategori,
    required this.stok,
    required this.gambar,
  });

  bool get isLow => stok <= 3;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 187,
      height: 232,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFDBDFEA),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// MENU
            Align(
              alignment: Alignment.topRight,
              child: _MenuButton(
                alat: {
                  "nama": nama,
                  "kategori": kategori,
                  "stok": stok,
                  "status": stok <= 3 ? "Low" : "Ready",
                  "gambar": gambar,
                },
              ),
            ),

            const SizedBox(height: 3),

            /// GAMBAR
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  gambar,
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 6),

            /// NAMA
            Text(
              nama,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                height: 1.1,
                color: Color(0xFF0E0A26),
              ),
            ),

            const SizedBox(height: 5),

            /// KATEGORI
            Text(
              kategori,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w300,
                height: 1.1,
                color: Color(0xFF4B4376),
              ),
            ),

            const SizedBox(height: 6),

            /// BADGE + STOK
            Row(
              children: [
                _StockBadge(stok: stok),
                const Spacer(),
                Text(
                  "Stok $stok",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF0E0A26),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//MENU
class _MenuButton extends StatelessWidget {
  final Map<String, dynamic> alat;

  const _MenuButton({required this.alat});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          showDialog(
            context: context,
            builder: (_) => AlatAddEdit(alat: alat),
          );
        }
         if (value == 'delete') {
          showDialog(
            context: context,
            builder: (_) => ConfirmActionPopup(
              title: 'Hapus Alat',
              message: 'Anda yakin menghapus\nalat ${alat["nama"]}?',
              confirmText: 'Hapus',
              onConfirm: () {
                Navigator.pop(context);
              },
            ),
          );
        }
      },
      
      constraints: const BoxConstraints(
        minWidth: 41,
        maxWidth: 41,
        minHeight: 75,
      ),
      icon: const Icon(Icons.more_vert, size: 20, color: Color(0xFF0E0A26)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF432E54)),
      ),
      color: const Color(0xFFD9D9D9),
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 'edit',
          height: 36,
          child: Center(child: Icon(Icons.edit, size: 18)),
        ),
        PopupMenuItem(
          value: 'delete',
          height: 36,
          child: Center(child: Icon(Icons.delete_outline, size: 18)),
        ),
      ],
    );
  }
}

//BADGE
class _StockBadge extends StatelessWidget {
  final int stok;
  const _StockBadge({required this.stok});

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = stok == 0;
    return Container(
      width: 49,
      height: 16,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isEmpty ? const Color(0xFFFDE7E7) : const Color(0xFFD7F8D8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEmpty ? const Color(0xFF9B1A1A) : const Color(0xFF026C09),
        ),
      ),
      child: Text(
        isEmpty ? "Kosong" : "Tersedia",
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isEmpty ? const Color(0xFF9B1A1A) : const Color(0xFF026C09),
        ),
      ),
    );
  }
}
