import 'package:flutter/material.dart';
import 'package:brantaspinjam/widgets/card_dashboard.dart';
import 'package:brantaspinjam/shared/enums.dart'; 

class DashboardScreen extends StatelessWidget {
  final UserRole role;

  const DashboardScreen({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ADMIN 
          if (role == UserRole.admin) ...[
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: const [
                DashboardCard(icon: Icons.inventory_2, title: "Alat", value: "11"),
                DashboardCard(icon: Icons.people, title: "Pengguna", value: "8"),
                DashboardCard(icon: Icons.category, title: "Kategori", value: "5"),
                DashboardCard(icon: Icons.assignment, title: "Peminjaman", value: "10"),
              ],
            ),

            const SizedBox(height: 24),

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
              title: "Pinjam",
              subtitle: "Egi Dwi / Peminjam",
              date: "19/1/2026",
            ),
          ],

          // PETUGAS 
          if (role == UserRole.petugas) ...[
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: const [
                DashboardCard(icon: Icons.assignment, title: "Pengajuan", value: "6"),
                DashboardCard(icon: Icons.inventory, title: "Dipinjam", value: "4"),
                DashboardCard(icon: Icons.assignment_turned_in, title: "Kembali", value: "3"),
                DashboardCard(icon: Icons.warning, title: "Terlambat", value: "1"),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Aktivitas",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B4376),
                  ),
                ),

                SizedBox(
                  width: 112,
                  height: 42,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFF8294C4),
                      side: const BorderSide(color: Color(0xFF4B4376)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Cetak",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const ActivityCard(
              title: "Mengajukan Peminjaman",
              subtitle: "Mobil Toko / Peminjam",
              date: "19/1/2026",
            ),
          ],

          // PEMINJAM 
          if (role == UserRole.peminjam) ...[
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: const [
                DashboardCard(icon: Icons.assignment, title: "Pengajuan", value: "2"),
                DashboardCard(icon: Icons.inventory, title: "Dipinjam", value: "1"),
                DashboardCard(icon: Icons.warning, title: "Terlambat", value: "0"),
                DashboardCard(icon: Icons.check_circle, title: "Selesai", value: "5"),
              ],
            ),

            const SizedBox(height: 24),

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
              title: "Dipinjam",
              subtitle: "Laptop Asus",
              date: "19/1/2026",
            ),
          ],
        ],
      ),
    );
  }
}
