import 'package:flutter/material.dart';
import 'package:brantaspinjam/widgets/card_cariadd.dart';
import 'package:brantaspinjam/widgets/card_popup.dart';
import 'package:brantaspinjam/widgets/card_denda.dart';
import 'package:brantaspinjam/screen/admin/denda/denda_add_edit.dart';

class DendaScreen extends StatefulWidget {
  const DendaScreen({super.key});

  @override
  State<DendaScreen> createState() => _DendaScreenState();
}

class _DendaScreenState extends State<DendaScreen> {
  String searchQuery = "";

  final List<Map<String, dynamic>> dendaList = [
    {'nama': 'Telat Pengembalian', 'nominal': 5000},
    {'nama': 'Alat Rusak', 'nominal': 25000},
    {'nama': 'Hilang', 'nominal': 100000},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredDenda = dendaList.where((denda) {
      return denda['nama'].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // SEARCH
          SearchCard(
            hint: "Cari denda",
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),

          const SizedBox(height: 12),

          // ADD
          AddButtonCard(
            title: "Tambah Denda",
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => const DendaAddEdit(),
              );
            },
          ),

          const SizedBox(height: 16),

          // LIST
          Expanded(
            child: filteredDenda.isEmpty
                ? const Center(child: Text("Denda tidak ditemukan"))
                : ListView.separated(
                    itemCount: filteredDenda.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final denda = filteredDenda[index];

                      return CardDenda(
                        nama: denda['nama'],
                        nominal: denda['nominal'],
                        onEdit: () {
                          showDialog(
                            context: context,
                            builder: (_) => DendaAddEdit(denda: denda),
                          );
                        },
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (_) => ConfirmActionPopup(
                              title: "Hapus Denda",
                              message: "Anda yakin menghapus data denda ini?",
                              confirmText: "Hapus",
                              onConfirm: () {
                              
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
