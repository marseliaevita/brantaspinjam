import 'package:flutter/material.dart';
import 'package:brantaspinjam/widgets/card_popup.dart';

class PeminjamanCekPopup extends StatefulWidget {
  const PeminjamanCekPopup({super.key});

  @override
  State<PeminjamanCekPopup> createState() => _PeminjamanCekPopupState();
}

class _PeminjamanCekPopupState extends State<PeminjamanCekPopup> {
  final kondisiController = TextEditingController();
  final terlambatController = TextEditingController();
  final dendaKerusakanController = TextEditingController();

  int dendaTerlambat = 0;
  final int dendaPerHari = 5000;

  void _hitungDenda(String value) {
    final hari = int.tryParse(value) ?? 0;
    setState(() {
      dendaTerlambat = hari * dendaPerHari;
    });
  }

  Widget _cardInput({
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E0A26),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF4B4376)),
          ),
          child: child,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CardPopup(
      title: "Cek Pengembalian",
      width: 600,
      height: 470,
      submitText: "Simpan",
      onCancel: () => Navigator.pop(context),
      onSubmit: () {
        Navigator.pop(context);
      },
      content: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// KONDISI
          _cardInput(
            label: "Kondisi Alat",
            child: TextField(
              controller: kondisiController,
              decoration: const InputDecoration(
                hintText: "Baik / Lecet / Rusak",
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// TERLAMBAT
          _cardInput(
            label: "Terlambat (hari)",
            child: TextField(
              controller: terlambatController,
              keyboardType: TextInputType.number,
              onChanged: _hitungDenda,
              decoration: const InputDecoration(
                hintText: "0",
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// DENDA OTOMATIS
          _cardInput(
            label: "Denda Terlambat",
            child: Text(
              "Rp $dendaTerlambat",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// DENDA KERUSAKAN
          _cardInput(
            label: "Denda Kerusakan",
            child: TextField(
              controller: dendaKerusakanController,
              decoration: const InputDecoration(
                hintText: "Contoh: LCD pecah",
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
