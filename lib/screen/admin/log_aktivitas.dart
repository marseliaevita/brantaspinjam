import 'package:flutter/material.dart';
import 'package:brantaspinjam/widgets/card_dashboard.dart';

class LogAktivitasScreen extends StatelessWidget {
  const LogAktivitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> aktivitas = [
      {
        'title': 'Peminjaman Disetujui',
        'subtitle': 'Laptop ASUS disetujui oleh petugas',
        'date': '12 Jan 2026',
      },
      {
        'title': 'Pengembalian',
        'subtitle': 'Kamera Canon telah dikembalikan',
        'date': '13 Jan 2026',
      },
      {
        'title': 'Denda Ditambahkan',
        'subtitle': 'Denda keterlambatan 2 hari',
        'date': '14 Jan 2026',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: aktivitas.isEmpty
                ? const Center(
                    child: Text("Belum ada aktivitas"),
                  )
                : ListView.separated(
                    itemCount: aktivitas.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = aktivitas[index];

                      return ActivityCard(
                        title: item['title']!,
                        subtitle: item['subtitle']!,
                        date: item['date']!,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
