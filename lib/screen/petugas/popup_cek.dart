import 'package:flutter/material.dart';
import 'package:brantaspinjam/model/model_peminjaman.dart';
import 'package:brantaspinjam/services/petugas_services.dart';
import 'package:brantaspinjam/services/denda_service.dart';
import 'package:brantaspinjam/widgets/card_popup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PeminjamanCekPopup extends StatefulWidget {
  final PeminjamanModel data;
  final VoidCallback? onRefresh;

  const PeminjamanCekPopup({
    super.key,
    required this.data,
    this.onRefresh,
  });

  @override
  State<PeminjamanCekPopup> createState() => _PeminjamanCekPopupState();
}

class _PeminjamanCekPopupState extends State<PeminjamanCekPopup> {
  final kondisiController = TextEditingController();
  final terlambatController = TextEditingController(text: '0');

  List<Map<String, dynamic>> listDendaKerusakan = [];
  Map<String, dynamic>? dendaKerusakanTerpilih;

  int tarifDendaTerlambat = 0;
  int hasilHitungDendaTerlambat = 0;
  int totalDendaKeseluruhan = 0;

  @override
  void initState() {
    super.initState();
    _fetchDenda();
    kondisiController.text = widget.data.kondisi ?? '';

  }

  Future<void> _fetchDenda() async {
    try {
      final dendaService = DendaService(Supabase.instance.client);
      final allDenda = await dendaService.getDenda();

      final dendaTerlambatRow = allDenda.firstWhere(
        (d) => d['jenis_denda'].toString().toLowerCase().contains('terlambat'),
        orElse: () => {'tarif': 0},
      );
      tarifDendaTerlambat = (dendaTerlambatRow['tarif'] as num).toInt();

      listDendaKerusakan = allDenda
          .where((d) => !d['jenis_denda'].toString().toLowerCase().contains('terlambat'))
          .toList();

      setState(() {});
      _hitungHariTerlambat();
      _hitungDenda();
    } catch (e) {
      debugPrint('Gagal fetch denda: $e');
    }
  }

  void _hitungHariTerlambat() {
  final data = widget.data;

  if (data.tanggalDikembalikan == null) return;

  final batas = data.tanggalBatas;
  final kembali = data.tanggalDikembalikan!;

  final selisih = kembali.difference(batas).inDays;

  final hariTerlambat = selisih > 0 ? selisih : 0;

  terlambatController.text = hariTerlambat.toString();
  hasilHitungDendaTerlambat = hariTerlambat * tarifDendaTerlambat;
}


  void _hitungDenda() {
    final terlambatHari = int.tryParse(terlambatController.text) ?? 0;
    hasilHitungDendaTerlambat = terlambatHari * tarifDendaTerlambat;

    int tarifKerusakan = dendaKerusakanTerpilih != null
        ? (dendaKerusakanTerpilih!['tarif'] as num).toInt()
        : 0;

    setState(() {
      totalDendaKeseluruhan = hasilHitungDendaTerlambat + tarifKerusakan;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int terlambatHari = int.tryParse(terlambatController.text) ?? 0;
    return CardPopup(
      title: "Cek Pengembalian",
      width: 600,
      height: 470,
      submitText: "Simpan",
      onCancel: () => Navigator.pop(context),
      onSubmit: () async {
        final berhasil = await cekPengembalian(
          idPeminjaman: widget.data.idPeminjaman!,
          kondisi: kondisiController.text,
          terlambatHari: int.tryParse(terlambatController.text) ?? 0,
          tarifTerlambat: tarifDendaTerlambat,
          dendaKerusakan: dendaKerusakanTerpilih != null
              ? (dendaKerusakanTerpilih!['tarif'] as num).toInt()
              : 0,
          idDenda: dendaKerusakanTerpilih?['id_denda'],
        );

        if (berhasil) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pengembalian berhasil disimpan')),
          );
          widget.onRefresh?.call();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menyimpan pengembalian')),
          );
        }
      },
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _label('Kondisi Alat'),
            _textField(double.infinity, kondisiController, onChanged: (v) {}),

            const SizedBox(height: 20),
            const Divider(thickness: 1.5),
            const Text(
              "PENALTY & DENDA",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 10),

            // Denda Terlambat
            _cardDenda(
            label: "Denda Terlambat (Sistem)",
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$terlambatHari Hari x Rp $tarifDendaTerlambat"),
                Text(
                  "Rp $hasilHitungDendaTerlambat",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Denda Kerusakan
            _cardDenda(
              label: "Denda Kerusakan Barang (Pilih)",
              content: DropdownButtonHideUnderline(
                child: DropdownButton<Map<String, dynamic>>(
                  isDense: true,
                  isExpanded: true,
                  value: dendaKerusakanTerpilih,
                  hint: const Text(
                    "Pilih Kerusakan",
                    style: TextStyle(fontSize: 12),
                  ),
                  items: listDendaKerusakan.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text("${item['jenis_denda']} (Rp ${item['tarif']})",
                          style: const TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      dendaKerusakanTerpilih = val;
                      _hitungDenda();
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 15),

            // TOTAL AKHIR
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade700,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "TOTAL TAGIHAN",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Rp $totalDendaKeseluruhan",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      );

  Widget _textField(double width, TextEditingController controller,
          {Function(String)? onChanged}) =>
      SizedBox(
        width: width,
        height: 38,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
      );

  Widget _cardDenda({required String label, required Widget content}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueGrey.shade100),
            ),
            child: content,
          ),
        ],
      );
}
