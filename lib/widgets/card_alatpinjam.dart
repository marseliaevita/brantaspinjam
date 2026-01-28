import 'package:flutter/material.dart';
import 'package:brantaspinjam/shared/enums.dart';

class AlatPinjamCard extends StatelessWidget {
  final AlatCardVariant variant;

  final String nama;
  final String kategori;
  final int stok;
  final String gambar;
  final VoidCallback? onTambah;
  final VoidCallback? onKurang;

  // popup
  final int? jumlah;
  final VoidCallback? onTapJumlah;

  // list
  final VoidCallback? onAjukan;
  final bool showButton;

  const AlatPinjamCard({
    super.key,
    this.variant = AlatCardVariant.list,
    required this.nama,
    required this.kategori,
    required this.stok,
    required this.gambar,
    this.jumlah,
    this.onTapJumlah,
    this.onAjukan,
    this.showButton = true,
    this.onTambah,
    this.onKurang,
  });

  bool get isPopup => variant == AlatCardVariant.popup;
  bool get isLow => stok <= 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isPopup ? 306 : 379,
      height: isPopup ? 120 : 183,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF8294C4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              gambar,
              width: isPopup ? 80 : 160,
              height: isPopup ? 80 : 160,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: isPopup
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Text(
                  nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isPopup ? 16 : 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  kategori,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 8),

                // JUMLAH (POPUP)
                isPopup
                    ? Row(
                        children: [
                          _qtyButton(icon: Icons.remove, onTap: onKurang),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              (jumlah ?? 1).toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          _qtyButton(icon: Icons.add, onTap: onTambah),
                        ],
                      )
                    : Row(
                        children: [
                          _StockBadge(stok: stok),
                          const SizedBox(width: 8),
                          Text(
                            "Stok $stok",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                // BUTTON LIST
                if (!isPopup && showButton) ...[
                  const Spacer(),
                  SizedBox(
                    width: 178,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: isLow ? null : onAjukan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E0A26),
                        disabledBackgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Ajukan Pinjam",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// BADGE JUMLAH
Widget _qtyButton({required IconData icon, VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: onTap == null ? Colors.grey.shade300 : const Color(0xFF8294C4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18, color: Colors.white),
    ),
  );
}

// BADGE STOK 
class _StockBadge extends StatelessWidget {
  final int stok;
  const _StockBadge({required this.stok});

  @override
  Widget build(BuildContext context) {
    final isEmpty = stok <= 0;

    return Container(
      width: 60,
      height: 20,
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
