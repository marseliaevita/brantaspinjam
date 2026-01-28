import 'package:flutter/material.dart';
import 'package:brantaspinjam/widgets/card_peminjaman.dart';
import 'package:brantaspinjam/widgets/card_cariadd.dart';
import 'package:brantaspinjam/shared/enums.dart';
import 'package:brantaspinjam/model/model_peminjaman.dart';

class PengembalianPetugasScreen extends StatefulWidget {
  const PengembalianPetugasScreen({super.key});

  @override
  State<PengembalianPetugasScreen> createState() =>
      _PengembalianPetugasScreenState();
}

class _PengembalianPetugasScreenState
    extends State<PengembalianPetugasScreen> {
  String searchQuery = '';
  PeminjamanStatus? selectedStatus;

  // =====================
  // DUMMY DATA
  // =====================
  final dummyData = [
    PeminjamanModel(
      nama: "Andi",
      alat: "Kamera",
      tanggalPinjam: DateTime(2026, 1, 15),
      tanggalBatas: DateTime(2026, 1, 20),
      tanggalDikembalikan: DateTime(2026, 1, 18),
      status: PeminjamanStatus.dikembalikan,
    ),
    PeminjamanModel(
      nama: "Budi",
      alat: "Laptop",
      tanggalPinjam: DateTime(2026, 1, 14),
      tanggalBatas: DateTime(2026, 1, 19),
      tanggalDikembalikan: DateTime(2026, 1, 19),
      status: PeminjamanStatus.selesai,
    ),
  ];

  final statusList = [
    null,
    PeminjamanStatus.dikembalikan,
    PeminjamanStatus.selesai,
  ];

  String getStatusLabel(PeminjamanStatus? status) {
    switch (status) {
      case PeminjamanStatus.dikembalikan:
        return 'Dikembalikan';
      case PeminjamanStatus.selesai:
        return 'Selesai';
      default:
        return 'Semua';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = dummyData.where((e) {
      final statusMatch = selectedStatus == null || e.status == selectedStatus;
      final searchMatch = e.nama.toLowerCase().contains(searchQuery.toLowerCase());
      return statusMatch && searchMatch;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SearchCard(
            hint: "Cari peminjam",
            onChanged: (v) => setState(() => searchQuery = v),
          ),

          const SizedBox(height: 16),

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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF4B4376)
                          : const Color(0xFFDBDFEA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      getStatusLabel(status),
                      style: TextStyle(
                        color: selected ? Colors.white : const Color(0xFF4B4376),
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
            child: ListView(
              children: filteredData.map((e) {
                return PeminjamanCard(
                  mode: CardMode.petugas,
                  data: e, 
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
