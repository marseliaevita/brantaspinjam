import 'package:flutter/material.dart';
import 'package:brantaspinjam/widgets/card_dashboard.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DASHBOARD 
          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: const [
              DashboardCard(
                icon: Icons.inventory_2,
                title: "Alat",
                value: "11",
              ),
              DashboardCard(
                icon: Icons.people,
                title: "Pengguna",
                value: "8",
              ),
              DashboardCard(
                icon: Icons.category,
                title: "Kategori",
                value: "5",
              ),
              DashboardCard(
                icon: Icons.assignment,
                title: "Peminjaman",
                value: "10",
              ),
            ],
          ),

          const SizedBox(height: 24),

          // AKTIVITAS
          const Text(
            "Aktivitas",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B4376),
            ),
          ),
          const SizedBox(height: 12),

          const ActivityCard(
            title: "Mengajukan Peminjaman",
            subtitle: "Mobil Toko/Peminjam",
            date: "19/1/2026",
          ),
          const SizedBox(height: 10),
          const ActivityCard(
            title: "Pinjam",
            subtitle: "Egi Dwi/Peminjam",
            date: "19/1/2026",
          ),
        ],
      ),
    );
  }
}
