import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brantaspinjam/services/denda_service.dart';
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
  bool isLoading = true;
  List<Map<String, dynamic>> dendaList = [];
  late DendaService dendaService;

  @override
  void initState() {
    super.initState();
    dendaService = DendaService(Supabase.instance.client);
    fetchDenda();
  }

  Future<void> fetchDenda() async {
    try {
      final data = await dendaService.getDenda();
      if (!mounted) return;
      setState(() {
        dendaList = data
            .map(
              (d) => {
                'nama': d['jenis_denda'],
                'nominal': (d['tarif'] as num).toInt(),
                'id_denda': d['id_denda'],  
              },
            )
            .toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> deleteDenda(int id) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => isLoading = true);

    try {
      await dendaService.deleteDenda(id);
      if (!mounted) return;
      await fetchDenda();
      messenger.showSnackBar(
        const SnackBar(content: Text('Denda berhasil dihapus')),
      );
    } catch (e) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Gagal menghapus denda')),
      );
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

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
              ).then((_) => fetchDenda());
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
                          ).then((_) => fetchDenda());
                        },
                        onDelete: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (_) => ConfirmActionPopup(
                                  title: "Hapus Denda",
                                  message:
                                      "Anda yakin menghapus data denda ini?",
                                  confirmText: "Hapus",
                                  onConfirm: () {
                                    Navigator.pop(context, true);
                                  },
                                ),
                              );

                              if (confirmed != true) return;

                              await deleteDenda(denda['id_denda']);
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