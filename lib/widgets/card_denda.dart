import 'package:flutter/material.dart';

class CardDenda extends StatelessWidget {
  final String nama;
  final int nominal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CardDenda({
    super.key,
    required this.nama,
    required this.nominal,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 395,
      height: 179,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFACB1D6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF8294C4),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // ICON
              Container(
                width: 95,
                height: 73,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.payments_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 16),

              // TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatRupiah(nominal),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Container(width: 352, height: 1, color: Colors.white),
          const Spacer(),

          // BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _button("Edit", Icons.edit, onEdit),
              _button("Hapus", Icons.delete, onDelete),
            ],
          ),
        ],
      ),
    );
  }

  // BUTTON 
  Widget _button(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 112,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFF432E54).withOpacity(0.42),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 10, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NOMINAL
  static String _formatRupiah(int value) {
    return 'Rp ${value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    )}';
  }
}
