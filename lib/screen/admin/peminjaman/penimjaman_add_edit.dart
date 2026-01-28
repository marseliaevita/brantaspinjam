import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:brantaspinjam/model/model_peminjaman.dart';
import 'package:brantaspinjam/shared/enums.dart';
import 'package:brantaspinjam/widgets/card_popup.dart';

class PeminjamanAddEdit extends StatefulWidget {
  final PeminjamanModel? data;

  const PeminjamanAddEdit({super.key, this.data});

  @override
  State<PeminjamanAddEdit> createState() => _PeminjamanAddEditState();
}

class _PeminjamanAddEditState extends State<PeminjamanAddEdit> {
  late TextEditingController namaController;
  late TextEditingController alatController;
  late TextEditingController tanggalPinjamController;
  late TextEditingController tanggalBatasController;
  late TextEditingController tanggalDikembalikanController;
  late TextEditingController kondisiController;
  late TextEditingController dendaTerlambatController;

  PeminjamanStatus statusValue = PeminjamanStatus.pengajuan;

  bool get isEdit => widget.data != null;

  final DateFormat _df = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();

    final data = widget.data;

    namaController = TextEditingController(text: data?.nama ?? '');
    alatController = TextEditingController(text: data?.alat ?? '');

    tanggalPinjamController = TextEditingController(
      text: data != null ? _df.format(data.tanggalPinjam) : '',
    );
    tanggalBatasController = TextEditingController(
      text: data != null ? _df.format(data.tanggalBatas) : '',
    );
    tanggalDikembalikanController = TextEditingController(
      text: data?.tanggalDikembalikan != null
          ? _df.format(data!.tanggalDikembalikan!)
          : '',
    );

    kondisiController = TextEditingController(text: data?.kondisi ?? '');
    dendaTerlambatController = TextEditingController(
      text: data?.dendaTerlambatHari?.toString() ?? '',
    );

    statusValue = data?.status ?? PeminjamanStatus.pengajuan;
  }

  @override
  Widget build(BuildContext context) {
    return CardPopup(
      title: isEdit ? 'Edit Peminjaman' : 'Tambah Peminjaman',
      width: 350,
      height: isEdit ? 520 : 480,
      submitText: isEdit ? 'Update' : 'Simpan',
      onCancel: () => Navigator.pop(context),
      onSubmit: _handleSubmit,
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Nama'),
              _textField(257, namaController),

              const SizedBox(height: 14),
              _label('Alat'),
              _textField(257, alatController),

              const SizedBox(height: 16),
              Row(
                children: [
                  _dateField('Tanggal Pinjam', tanggalPinjamController),
                  const SizedBox(width: 16),
                  _dateField('Tanggal Batas', tanggalBatasController),
                ],
              ),

              /// TANGGAL DIKEMBALIKAN
              if (statusValue == PeminjamanStatus.dikembalikan ||
                  statusValue == PeminjamanStatus.selesai) ...[
                const SizedBox(height: 16),
                _label('Tanggal Dikembalikan'),
                _textField(257, tanggalDikembalikanController),
              ],

              /// STATUS (EDIT ONLY)
              if (isEdit) ...[
                const SizedBox(height: 16),
                _label('Status'),
                SizedBox(
                  width: 257,
                  height: 36,
                  child: TextField(
                    readOnly: true,
                    controller:
                        TextEditingController(text: statusValue.label),
                    onTap: _nextStatus,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ],

              /// KONDISI + DENDA (SELESAI)
              if (statusValue == PeminjamanStatus.selesai) ...[
                const SizedBox(height: 16),
                const Divider(),

                _label('Kondisi'),
                _textField(257, kondisiController),

                const SizedBox(height: 12),
                _label('Denda Terlambat (hari)'),
                _textField(80, dendaTerlambatController),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // LOGIC
  void _nextStatus() {
    setState(() {
      if (statusValue == PeminjamanStatus.dipinjam) {
        statusValue = PeminjamanStatus.dikembalikan;
      } else if (statusValue == PeminjamanStatus.dikembalikan) {
        statusValue = PeminjamanStatus.selesai;
      }
    });
  }

  void _handleSubmit() {
    final model = PeminjamanModel(
      nama: namaController.text,
      alat: alatController.text,
      tanggalPinjam: _df.parse(tanggalPinjamController.text),
      tanggalBatas: _df.parse(tanggalBatasController.text),
      tanggalDikembalikan:
          tanggalDikembalikanController.text.isEmpty
              ? null
              : _df.parse(tanggalDikembalikanController.text),
      status: statusValue,
      kondisi:
          statusValue == PeminjamanStatus.selesai ? kondisiController.text : null,
      dendaTerlambatHari:
          statusValue == PeminjamanStatus.selesai
              ? int.tryParse(dendaTerlambatController.text)
              : null,
    );

    Navigator.pop(context, model);
  }

  // UI HELPER
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _textField(double width, TextEditingController controller) {
    return SizedBox(
      width: width,
      height: 36,
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  Widget _dateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        _textField(120, controller),
      ],
    );
  }
}
