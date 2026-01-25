import 'package:flutter/material.dart';
import 'package:brantaspinjam/widgets/card_popup.dart';

class KategoriAddEdit extends StatefulWidget {
  final Map<String, dynamic>? kategori;

  const KategoriAddEdit({super.key, this.kategori});

  @override
  State<KategoriAddEdit> createState() => _KategoriAddEditState();
}

class _KategoriAddEditState extends State<KategoriAddEdit> {
  late TextEditingController namaController;

  bool get isEdit => widget.kategori != null;

  @override
  void initState() {
    super.initState();
    namaController =
        TextEditingController(text: widget.kategori?['nama'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return CardPopup(
      title: isEdit ? 'Edit Kategori' : 'Tambah Kategori',
      width: 350,
      height: 290,
      submitText: isEdit ? 'Update' : 'Simpan',
      onCancel: () => Navigator.pop(context),
      onSubmit: () {
        final nama = namaController.text.trim();

        if (nama.isEmpty) return;

        Navigator.pop(context);
      },
      content: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Nama kategori'),
            _textField(width: 257, controller: namaController),
          ],
        ),
      ),
    );
  }
}

// WIDGET
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

Widget _label(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(fontSize: 15, color: Color(0xFF0E0A26)),
    ),
  );
}
