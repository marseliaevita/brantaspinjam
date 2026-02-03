import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:brantaspinjam/shared/enums.dart';
import 'package:brantaspinjam/services/user_service.dart';
import 'package:brantaspinjam/services/dashboard_service.dart';
import 'package:brantaspinjam/screen/dashboard/report_screen.dart';
import 'package:brantaspinjam/widgets/card_dashboard.dart';
import 'package:brantaspinjam/services/supabase_config.dart';


class DashboardScreen extends StatefulWidget {
  final UserRole role;
  const DashboardScreen({super.key, required this.role});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  Map<String, String> _stats = {};
  List<Map<String, dynamic>> _listData = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

 void _cetakLaporan() async {
  if (_listData.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Belum ada data untuk dicetak")),
    );
    return;
  }

  await ReportScreen.generateReport(context, _listData);
}




  Future<void> _loadDashboardData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final userId = SupabaseConfig.client.auth.currentUser?.id ?? '';
      final dService = DashboardService();
      final uService = UserService();

      final results = await Future.wait([
        dService.getStats(widget.role.name, userId),
        widget.role == UserRole.peminjam
            ? dService.getMyLoans(userId)
            : uService.getLogs(),
      ]);

      if (mounted) {
        setState(() {
          _stats = Map<String, String>.from(results[0] as Map);
          _listData = results[1] as List<Map<String, dynamic>>;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Gagal memuat dashboard: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatCards(),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.role == UserRole.peminjam
                      ? "Pinjaman Saya"
                      : "Aktivitas Terbaru",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B4376),
                  ),
                ),

                if (widget.role == UserRole.petugas)
                  ElevatedButton.icon(
                    onPressed: _cetakLaporan,
                    icon: const Icon(Icons.print, size: 18),
                    label: const Text("Cetak"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B4376),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 24),

            _listData.isEmpty
                ? const Center(child: Text("Belum ada data"))
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _listData.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _listData[index];

                      if (widget.role == UserRole.petugas) {
                        return ActivityCard(
                          title: item['users']?['name'] ?? 'User',
                          subtitle:
                              "Status: ${item['status_peminjaman'].toString().toUpperCase()}",
                          date: DateFormat(
                            'dd/MM/yyyy HH:mm',
                          ).format(DateTime.parse(item['waktu'])),
                        );
                      }
                      if (widget.role == UserRole.peminjam) {
                        return ActivityCard(
                          title:
                              item['alat']['nama_alat'] ??
                              'Alat Tidak Diketahui',
                          subtitle:
                              "Status: ${item['status_peminjaman'].toString().toUpperCase()}",
                          date: DateFormat(
                            'dd/MM/yyyy',
                          ).format(DateTime.parse(item['tanggal_pinjam'])),
                        );
                      } else {
                        return ActivityCard(
                          title: item['users'] != null
                              ? item['users']['name']
                              : 'Sistem',
                          subtitle: item['aktivitas'] ?? '',
                          date: DateFormat(
                            'dd/MM/yyyy',
                          ).format(DateTime.parse(item['waktu'])),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCards() {
    List<DashboardCard> cards = [];
    if (widget.role == UserRole.admin) {
      cards = [
        DashboardCard(
          icon: Icons.handyman_rounded,
          title: "Alat",
          value: _stats['alat'] ?? "0",
        ),
        DashboardCard(
          icon: Icons.people,
          title: "Pengguna",
          value: _stats['users'] ?? "0",
        ),
        DashboardCard(
          icon: Icons.category,
          title: "Kategori",
          value: _stats['kategori'] ?? "0",
        ),
        DashboardCard(
          icon: Icons.sync_alt_rounded,
          title: "Peminjaman",
          value: _stats['pinjam'] ?? "0",
        ),
      ];
    } else if (widget.role == UserRole.petugas) {
      cards = [
        DashboardCard(
          icon: Icons.playlist_add_rounded,
          title: "Pengajuan",
          value: _stats['pengajuan'] ?? "0",
        ),
        DashboardCard(
          icon: Icons.inventory,
          title: "Dipinjam",
          value: _stats['dipinjam'] ?? "0",
        ),
        DashboardCard(
          icon: Icons.check_circle_rounded,
          title: "Kembali",
          value: _stats['kembali'] ?? "0",
        ),
        DashboardCard(
          icon: Icons.warning,
          title: "Terlambat",
          value: _stats['terlambat'] ?? "0",
        ),
      ];
    } else {
      cards = [
        DashboardCard(
          icon: Icons.playlist_add_rounded,
          title: "Pengajuan",
          value: _stats['pengajuan'] ?? "0",
        ),
        DashboardCard(
          icon: Icons.inventory,
          title: "Dipinjam",
          value: _stats['dipinjam'] ?? "0",
        ),
        DashboardCard(
          icon: Icons.warning,
          title: "Terlambat",
          value: _stats['terlambat'] ?? "0",
        ),
        DashboardCard(
          icon: Icons.check_circle,
          title: "Selesai",
          value: _stats['selesai'] ?? "0",
        ),
      ];
    }
    return Wrap(spacing: 15, runSpacing: 15, children: cards);
  }
}
