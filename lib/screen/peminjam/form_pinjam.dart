import 'package:flutter/material.dart';
import 'package:brantaspinjam/widgets/card_popup.dart';
import 'package:brantaspinjam/widgets/card_alatpinjam.dart';
import 'package:brantaspinjam/shared/enums.dart';

class AlatPinjamForm extends StatefulWidget {
  final Map<String, dynamic> alat;

  const AlatPinjamForm({super.key, required this.alat});

  @override
  State<AlatPinjamForm> createState() => _AlatPinjamFormState();
}

class _AlatPinjamFormState extends State<AlatPinjamForm> {
  int jumlah = 1;

  late TextEditingController tanggalPinjamCtrl;
  late TextEditingController tanggalKembaliCtrl;

  int get stok => widget.alat['stok'];

  @override
  void initState() {
    super.initState();
    tanggalPinjamCtrl = TextEditingController();
    tanggalKembaliCtrl = TextEditingController();
  }

  void tambahJumlah() {
    if (jumlah < stok) {
      setState(() => jumlah++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardPopup(
      title: 'Form Peminjaman',
      width: 420,
      height: 556,
      submitText: 'Ajukan',
      onCancel: () => Navigator.pop(context),
      onSubmit: _submit,
      content: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AlatPinjamCard(
              variant: AlatCardVariant.popup,
              nama: widget.alat['nama'],
              kategori: widget.alat['kategori'],
              stok: stok,
              gambar: widget.alat['gambar'],
              jumlah: jumlah,
              onTambah: jumlah < stok ? () => setState(() => jumlah++) : null,
              onKurang: jumlah > 1 ? () => setState(() => jumlah--) : null,
            ),

            const SizedBox(height: 20),

            _dateInput(
              context: context,
              label: 'Tanggal Peminjaman',
              controller: tanggalPinjamCtrl,
            ),

            const SizedBox(height: 12),

            _dateInput(
              context: context,
              label: 'Tanggal Pengembalian',
              controller: tanggalKembaliCtrl,
            ),
          ],
        ),
      ),
    );
  }


  void _submit() {
    if (tanggalPinjamCtrl.text.isEmpty || tanggalKembaliCtrl.text.isEmpty) {
      return;
    }

    final payload = {
      "id_alat": widget.alat["id"],
      "jumlah": jumlah,
      "tanggal_pinjam": tanggalPinjamCtrl.text,
      "tanggal_kembali": tanggalKembaliCtrl.text,
    };


    Navigator.pop(context);
  }
}

Widget _label(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF0E0A26),
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget _dateInput({
  required BuildContext context,
  required String label,
  required TextEditingController controller,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label(label),
      SizedBox(
        width: 260,
        height: 48,
        child: TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: "Pilih tanggal",
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4B4376), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF4B4376),
                width: 1.5,
              ),
            ),
          ),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              initialDate: DateTime.now(),
            );

            if (date != null) {
              controller.text =
                  "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
            }
          },
        ),
      ),
    ],
  );
}
