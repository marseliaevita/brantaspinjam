import 'package:flutter/material.dart';
import 'package:brantaspinjam/widgets/card_alatpinjam.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brantaspinjam/services/alat_service.dart';
import 'package:brantaspinjam/services/kategori_service.dart';
import 'package:brantaspinjam/screen/peminjam/form_pinjam.dart';

class PinjamAlatScreen extends StatefulWidget {
  const PinjamAlatScreen({super.key});

  @override
  State<PinjamAlatScreen> createState() => _PeminjamanListScreenState();
}

class _PeminjamanListScreenState extends State<PinjamAlatScreen> {
  String searchQuery = "";
  String selectedCategory = "Semua";

  late AlatService alatService;
  final List<Map<String, dynamic>> alatList = [];

  late KategoriService kategoriService;
  List<Map<String, dynamic>> kategoriList = [];
  List<String> kategoriNames = ["Semua"];
  Map<int, String> kategoriMap = {};

  @override
  void initState() {
    super.initState();
    alatService = AlatService(Supabase.instance.client);
    kategoriService = KategoriService(Supabase.instance.client);

    loadKategori();
    loadAlat();
  }

  Future<void> loadKategori() async {
    try {
      final data = await kategoriService.getKategori();
      setState(() {
        kategoriList = data;
        kategoriMap = {
          for (var k in data) k["id_kategori"]: k["nama_kategori"],
        };
        kategoriNames = ["Semua", ...data.map((k) => k["nama_kategori"])];
      });
    } catch (e) {
      print("Error load kategori: $e");
    }
  }

  Future<void> loadAlat() async {
    try {
      final data = await alatService.getAlat();
      setState(() {
        alatList.clear();
        alatList.addAll(
          data.map(
            (e) => {
              "id": e["id_alat"],
              "nama": e["nama_alat"],
              "kategori": kategoriMap[e["id_kategori"]] ?? " ",
              "stok": e["stok"],
              "gambar": e["gambar"] ?? "",
            },
          ),
        );
      });
    } catch (e) {
      print("Error load alat: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = alatList.where((a) {
      final namaMatch = a["nama"].toString().toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      final kategoriMatch =
          selectedCategory == "Semua" || a["kategori"] == selectedCategory;
      return namaMatch && kategoriMatch;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // SEARCH BAR
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF8294C4).withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFF8294C4), width: 2),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, size: 24, color: Color(0xFF4B4376)),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Cari alat",
                    ),
                    onChanged: (value) => setState(() => searchQuery = value),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // KATEGORI FILTER
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: kategoriNames.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final c = kategoriNames[i];
                final selected = selectedCategory == c;
                return GestureDetector(
                  onTap: () => setState(() => selectedCategory = c),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF0E0A26)
                          : const Color(0xFFDBDFEA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      c,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white
                            : const Color(0xFF4B4376),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // LIST ALAT
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final alat = filtered[i];
                return AlatPinjamCard(
                  nama: alat["nama"],
                  kategori: alat["kategori"],
                  stok: alat["stok"],
                  gambar: alat["gambar"],
                  onAjukan: alat["stok"] > 0
                      ? () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => AlatPinjamForm(alat: alat),
                          );
                        }
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
