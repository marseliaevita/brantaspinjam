import 'package:flutter/material.dart';
import 'package:brantaspinjam/widgets/card_peminjaman.dart';
import 'package:brantaspinjam/widgets/card_cariadd.dart';
import 'package:brantaspinjam/shared/enums.dart';
import 'package:brantaspinjam/model/model_peminjaman.dart';

class PeminjamanPetugasScreen extends StatefulWidget {
  const PeminjamanPetugasScreen({super.key});

  @override
  State<PeminjamanPetugasScreen> createState() =>
      _PeminjamanPetugasScreenState();
}

class _PeminjamanPetugasScreenState extends State<PeminjamanPetugasScreen> {
  String searchQuery = '';
  PeminjamanStatus? selectedStatus;

  // Dummy data pakai model
  final List<PeminjamanModel> dummyData = [
    PeminjamanModel(
      nama: "Andi",
      alat: "Laptop",
      tanggalPinjam: DateTime(2026, 1, 12),
      tanggalBatas: DateTime(2026, 1, 15),
      status: PeminjamanStatus.pengajuan,
    ),
    PeminjamanModel(
      nama: "Sinta",
      alat: "Proyektor",
      tanggalPinjam: DateTime(2026, 1, 10),
      tanggalBatas: DateTime(2026, 1, 14),
      status: PeminjamanStatus.dipinjam,
    ),
    PeminjamanModel(
      nama: "Budi",
      alat: "Kamera",
      tanggalPinjam: DateTime(2026, 1, 8),
      tanggalBatas: DateTime(2026, 1, 12),
      status: PeminjamanStatus.selesai,
    ),
    PeminjamanModel(
      nama: "Rina",
      alat: "Tripod",
      tanggalPinjam: DateTime(2026, 1, 6),
      tanggalBatas: DateTime(2026, 1, 10),
      status: PeminjamanStatus.ditolak,
    ),
  ];

  final statusList = [
    null,
    PeminjamanStatus.pengajuan,
    PeminjamanStatus.dipinjam,
    PeminjamanStatus.dikembalikan,
    PeminjamanStatus.selesai,
    PeminjamanStatus.ditolak,
  ];

  @override
  Widget build(BuildContext context) {
    final filteredData = dummyData.where((e) {
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
          // SEARCH
          SearchCard(
            hint: "Cari peminjam",
            onChanged: (v) => setState(() => searchQuery = v),
          ),

          const SizedBox(height: 16),

          // STATUS FILTER
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
                      status?.label ?? "Semua",
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

          // LIST CARD
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (_, index) {
                final item = filteredData[index];
                return PeminjamanCard(data: item, mode: CardMode.petugas);
              },
            ),
          ),
        ],
      ),
    );
  }
}
