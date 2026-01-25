import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brantaspinjam/services/kategori_service.dart';
import 'package:brantaspinjam/widgets/card_cariadd.dart';
import 'package:brantaspinjam/widgets/card_popup.dart';
import 'package:brantaspinjam/widgets/card_kategori.dart';
import 'package:brantaspinjam/screen/admin/kategori/kategori_add_edit.dart';

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({super.key});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  late KategoriService kategoriService;

  List<Map<String, dynamic>> kategoriList = [];
  String searchQuery = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    kategoriService = KategoriService(Supabase.instance.client);
    fetchKategori();
  }

  Future<void> fetchKategori() async {
    try {
      final data = await kategoriService.getKategori();
      setState(() {
        kategoriList = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredKategori = kategoriList.where((kategori) {
      final nama = kategori['nama_kategori'] ?? '';
      return nama.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // SEARCH
          SearchCard(
            hint: "Cari kategori",
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),

          const SizedBox(height: 12),

          // ADD
          AddButtonCard(
            title: "Tambah Kategori",
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => const KategoriAddEdit(),
              ).then((_) => fetchKategori());
            },
          ),

          const SizedBox(height: 16),

          // LIST
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredKategori.isEmpty
                    ? const Center(
                        child: Text(
                          "Kategori tidak ditemukan",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                : ListView.separated(
                    itemCount: filteredKategori.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                     final kategori = filteredKategori[index];

                          return CardKategori(
                            nama: kategori['nama_kategori'],
                            onEdit: () {
                              showDialog(
                                context: context,
                                builder: (_) => KategoriAddEdit(
                                  kategori: kategori,
                                ),
                              ).then((_) => fetchKategori());
                            },
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (_) => ConfirmActionPopup(
                              title: "Hapus Kategori",
                              message: "Anda yakin menghapus kategori ini?",
                              confirmText: "Hapus",
                              onConfirm: () {},
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
