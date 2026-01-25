import 'package:flutter/material.dart';
import 'package:brantaspinjam/widgets/card_popup.dart';

class AlatAddEdit extends StatefulWidget {
  final Map<String, dynamic>? alat;

  const AlatAddEdit({super.key, this.alat});

  @override
  State<AlatAddEdit> createState() => _AlatAddEditState();
}

class _AlatAddEditState extends State<AlatAddEdit> {
  late TextEditingController namaController;
  late TextEditingController kategoriController;
  late TextEditingController stokController;
  late TextEditingController statusController;

  bool get isEdit => widget.alat != null;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.alat?['nama'] ?? '');
    kategoriController =
        TextEditingController(text: widget.alat?['kategori'] ?? '');
    stokController =
        TextEditingController(text: widget.alat?['stok']?.toString() ?? '');
    statusController =
        TextEditingController(text: widget.alat?['status'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return CardPopup(
      title: isEdit ? 'Edit Alat' : 'Tambah Alat',
      width: 350,
      height: 584,
      submitText: isEdit ? 'Update' : 'Simpan',
      onCancel: () => Navigator.pop(context),
      onSubmit: () {
        Navigator.pop(context);
      },
      content: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Nama alat'),
            _textField(width: 257, controller: namaController),

            const SizedBox(height: 16),

            _label('Kategori'),
            _textField(width: 257, controller: kategoriController),

            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_label('Gambar'), _imageCard()],
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Stock'),
                    _textField(width: 112, controller: stokController),
                    const SizedBox(height: 6),
                    _label('Status'),
                    _textField(width: 112, controller: statusController),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//WIDGET
Widget _textField({required double width, TextEditingController? controller}) {
  return SizedBox(
    width: width,
    height: 48,
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: Color(0xFF4B4376), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: Color(0xFF4B4376), width: 1.5),
        ),
      ),
    ),
  );
}

Widget _imageCard() {
  return Container(
    width: 122,
    height: 130,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFF4B4376), width: 1),
    ),
    child: const Icon(Icons.image_outlined,
        size: 32, color: Color(0xFF4B4376)),
  );
}

Widget _label(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(fontSize: 15, color: Color(0xFF0E0A26)),
    ),
  );
}
