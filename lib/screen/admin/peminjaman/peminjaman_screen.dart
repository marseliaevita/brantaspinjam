import 'package:flutter/material.dart';
import 'package:brantaspinjam/services/peminjaman_services.dart';
import 'package:brantaspinjam/widgets/card_peminjaman.dart';
import 'package:brantaspinjam/widgets/card_cariadd.dart';
import 'package:brantaspinjam/shared/enums.dart';
import 'package:brantaspinjam/model/model_peminjaman.dart';
import 'package:brantaspinjam/screen/admin/peminjaman/penimjaman_add_edit.dart';

class PeminjamanAdminScreen extends StatefulWidget {
  const PeminjamanAdminScreen({super.key});

  @override
  State<PeminjamanAdminScreen> createState() => _PeminjamanAdminScreenState();
}

class _PeminjamanAdminScreenState extends State<PeminjamanAdminScreen> {
  String searchQuery = '';
  PeminjamanStatus? selectedStatus;
  List<PeminjamanModel> dataPeminjaman = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPeminjaman();
  }

  Future<void> _loadPeminjaman() async {
    setState(() => isLoading = true);
    try {
      final data = await fetchPeminjamanAdmin();
      print("Fetched peminjaman: ${data.length}");
      setState(() => dataPeminjaman = data);
    } catch (e) {
      print(e);
    } finally {
      setState(() => isLoading = false);
    }
  }

  final List<PeminjamanStatus?> statusList = const [
    null,
    PeminjamanStatus.pengajuan,
    PeminjamanStatus.dipinjam,
    PeminjamanStatus.dikembalikan,
    PeminjamanStatus.selesai,
    PeminjamanStatus.ditolak,
  ];

  String getStatusLabel(PeminjamanStatus? status) {
    if (status == null) return 'Semua';
    return status.label;
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = dataPeminjaman.where((e) {
      final statusMatch = selectedStatus == null || e.status == selectedStatus;
      final searchMatch = e.nama.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return statusMatch && searchMatch;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              SearchCard(
                width: 304,
                hint: "Cari data",
                onChanged: (value) => setState(() => searchQuery = value),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () async {
                  final bool? refresh = await showDialog<bool>(
                    context: context,
                    builder: (context) => const PeminjamanAddEdit(),
                  );

                  if (refresh == true) {
                    _loadPeminjaman();
                  }
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB3C8CF),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: statusList.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final status = statusList[i];
                final selected = selectedStatus == status;
                return GestureDetector(
                  onTap: () => setState(() => selectedStatus = status),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF4B4376)
                          : const Color(0xFFDBDFEA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      getStatusLabel(status),
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : const Color(0xFF4B4376),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredData.isEmpty
                ? const Center(child: Text("Tidak ada data"))
                : ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (_, index) {
                      final item = filteredData[index];
                      return PeminjamanCard(mode: CardMode.admin, data: item);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
