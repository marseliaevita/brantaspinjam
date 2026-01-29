import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brantaspinjam/services/denda_service.dart';
import 'package:brantaspinjam/widgets/card_popup.dart';

class DendaAddEdit extends StatefulWidget {
  final Map<String, dynamic>? denda;

  const DendaAddEdit({super.key, this.denda});

  @override
  State<DendaAddEdit> createState() => _DendaAddEditState();
}

class _DendaAddEditState extends State<DendaAddEdit> {
  late TextEditingController namaController;
  late TextEditingController nominalController;

  bool get isEdit => widget.denda != null;

  late DendaService dendaService;

@override
void initState() {
  super.initState();
  namaController = TextEditingController(text: widget.denda?['nama'] ?? '');
  nominalController = TextEditingController(
      text: widget.denda?['nominal']?.toString() ?? '');
  
  dendaService = DendaService(Supabase.instance.client); 
}


  @override
  Widget build(BuildContext context) {
    return CardPopup(
      title: isEdit ? 'Edit Denda' : 'Tambah Denda',
      width: 350,
      height: 350,
      submitText: isEdit ? 'Update' : 'Simpan',
      onCancel: () => Navigator.pop(context),
      onSubmit: () async {
  final nama = namaController.text.trim();
  final nominalText = nominalController.text.trim();
  if (nama.isEmpty || nominalText.isEmpty) return;

  final nominal = double.tryParse(nominalText);
  if (nominal == null) return;

  try {
    if (isEdit) {
      await dendaService.updateDenda(
        idDenda: widget.denda!['id_denda'],
        jenisDenda: nama,
        tarif: nominal,
      );
    } else {
      await dendaService.addDenda(jenisDenda: nama, tarif: nominal);
    }
    if (!mounted) return;
    Navigator.pop(context, true);
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal menyimpan denda: $e')),
    );
  }
},
      content: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Nama denda'),
            _textField(width: 257, controller: namaController),

            const SizedBox(height: 14),

            _label('Nominal denda'),
            _textField(
              width: 257,
              controller: nominalController,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}

// WIDGET

Widget _textField({
  required double width,
  TextEditingController? controller,
  TextInputType keyboardType = TextInputType.text,
}) {
  return SizedBox(
    width: width,
    height: 48,
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
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
