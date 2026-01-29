import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:brantaspinjam/widgets/card_popup.dart';
import 'package:brantaspinjam/services/alat_service.dart';
import 'package:brantaspinjam/services/kategori_service.dart';

class AlatAddEdit extends StatefulWidget {
  final Map<String, dynamic>? alat;

  const AlatAddEdit({super.key, this.alat});

  @override
  State<AlatAddEdit> createState() => _AlatAddEditState();
}

class _AlatAddEditState extends State<AlatAddEdit> {
  late TextEditingController namaController;
  late TextEditingController stokController;
  late AlatService alatService;
  late KategoriService kategoriService;

  List<Map<String, dynamic>> kategoriList = [];
  int? selectedKategori;

  bool get isEdit => widget.alat != null;

  String? selectedStatus;

  Uint8List? selectedImageBytes;
  String? existingImageUrl;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    alatService = AlatService(Supabase.instance.client);
    kategoriService = KategoriService(Supabase.instance.client);

    namaController = TextEditingController(
      text: widget.alat?['nama_alat'] ?? '',
    );
    stokController = TextEditingController(
      text: widget.alat?['stok']?.toString() ?? '',
    );
    selectedStatus = widget.alat?['status']?.toString().toLowerCase();

    existingImageUrl = widget.alat?['gambar'];

    _loadKategori();
  }

  Future<void> _loadKategori() async {
    try {
      final data = await kategoriService.getKategori();

      if (!mounted) return;

      setState(() {
        kategoriList = data;

        if (isEdit) {
          selectedKategori = widget.alat?['id_kategori'];
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal load kategori: $e')));
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        selectedImageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardPopup(
      title: isEdit ? 'Edit Alat' : 'Tambah Alat',
      width: 350,
      height: 584,
      submitText: isEdit ? 'Update' : 'Simpan',
      onCancel: () => Navigator.pop(context),
      onSubmit: _handleSubmit,
      content: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Nama alat'),
            _textField(width: 257, controller: namaController),
            const SizedBox(height: 16),

            _label('Kategori'),
            SizedBox(
              width: 257,
              height: 48,
              child: DropdownButtonFormField<int>(
                value: selectedKategori,
                items: kategoriList.map((kat) {
                  return DropdownMenuItem<int>(
                    value: kat['id_kategori'],
                    child: Text(kat['nama_kategori']),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedKategori = val;
                  });
                },
                decoration: _inputDecoration(),
              ),
            ),

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
                    SizedBox(
                      width: 112,
                      height: 48,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: selectedStatus,
                        items: const [
                          DropdownMenuItem(
                            value: 'tersedia',
                            child: Text('Tersedia'),
                          ),
                          DropdownMenuItem(
                            value: 'kosong',
                            child: Text('Kosong'),
                          ),
                        ],
                        onChanged: (val) {
                          setState(() {
                            selectedStatus = val;
                          });
                        },
                        decoration: _inputDecoration(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final nama = namaController.text.trim();
    final stok = int.tryParse(stokController.text.trim());
    final status = stok == 0 ? 'kosong' : 'tersedia';

    if (nama.isEmpty || selectedKategori == null || stok == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi dengan benar')),
      );
      return;
    }

    try {
      String? imageUrl;

      if (selectedImageBytes != null) {
        final fileName = 'alat_${DateTime.now().millisecondsSinceEpoch}.png';
        imageUrl = await alatService.uploadGambar(
          selectedImageBytes!,
          fileName,
        );
      } else {
        imageUrl = existingImageUrl;
      }

      if (isEdit) {
        await alatService.updateAlat(
          idAlat: widget.alat!['id_alat'],
          nama: nama,
          idKategori: selectedKategori!,
          stok: stok,
          status: status,
          gambarUrl: imageUrl,
        );
      } else {
        await alatService.addAlat(
          nama: nama,
          idKategori: selectedKategori!,
          stok: stok,
          status: status,
          gambarUrl: imageUrl,
        );
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan alat: $e')));
    }
  }

  // WIDGET INTERNAL 

  Widget _imageCard() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 122,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF4B4376), width: 1),
          image: selectedImageBytes != null
              ? DecorationImage(
                  image: MemoryImage(selectedImageBytes!),
                  fit: BoxFit.cover,
                )
              : existingImageUrl != null
              ? DecorationImage(
                  image: NetworkImage(existingImageUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: selectedImageBytes == null && existingImageUrl == null
            ? const Icon(
                Icons.image_outlined,
                size: 32,
                color: Color(0xFF4B4376),
              )
            : null,
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF4B4376), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF4B4376), width: 1.5),
      ),
    );
  }
}

// WIDGET GLOBAL

Widget _textField({required double width, TextEditingController? controller}) {
  return SizedBox(
    width: width,
    height: 48,
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
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
          borderSide: const BorderSide(color: Color(0xFF4B4376), width: 1.5),
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
