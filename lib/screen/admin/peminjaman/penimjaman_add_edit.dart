import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:brantaspinjam/model/model_peminjaman.dart';
import 'package:brantaspinjam/shared/enums.dart';
import 'package:brantaspinjam/widgets/card_popup.dart';
import 'package:brantaspinjam/services/denda_service.dart';

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

  int tarifDendaTerlambat = 0; 
  int hasilHitungDendaTerlambat = 0; 
  int totalDendaKeseluruhan = 0;
  
  List<Map<String, dynamic>> listDendaKerusakan = [];
  Map<String, dynamic>? dendaKerusakanTerpilih;

  PeminjamanStatus statusValue = PeminjamanStatus.pengajuan;
  bool get isEdit => widget.data != null;
  final DateFormat _df = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    final data = widget.data;

    namaController = TextEditingController(text: data?.nama ?? '');
    alatController = TextEditingController(text: data?.alat ?? '');
    tanggalPinjamController = TextEditingController(text: data != null ? _df.format(data.tanggalPinjam) : '');
    tanggalBatasController = TextEditingController(text: data != null ? _df.format(data.tanggalBatas) : '');
    tanggalDikembalikanController = TextEditingController(
      text: data?.tanggalDikembalikan != null ? _df.format(data!.tanggalDikembalikan!) : '',
    );
    kondisiController = TextEditingController(text: data?.kondisi ?? '');
    dendaTerlambatController = TextEditingController(text: data?.dendaTerlambatHari?.toString() ?? '0');
    statusValue = data?.status ?? PeminjamanStatus.pengajuan;

    _fetchSemuaDataDenda();
  }

  // FUNGSI LOGIC

  Future<void> _fetchSemuaDataDenda() async {
    try {
      final service = DendaService(Supabase.instance.client);
      final allDenda = await service.getDenda();

      setState(() {
        final dataTerlambat = allDenda.firstWhere(
          (e) => e['jenis_denda'].toString().toLowerCase() == 'terlambat',
          orElse: () => {'tarif': 5000},
        );
        tarifDendaTerlambat = (dataTerlambat['tarif'] as num).toInt();

        listDendaKerusakan = allDenda.where(
          (e) => e['jenis_denda'].toString().toLowerCase() != 'terlambat'
        ).toList();
      });
      _hitungDendaOtomatis();
    } catch (e) {
      debugPrint("Gagal ambil denda: $e");
    }
  }

  void _hitungDendaOtomatis() {
    if (tarifDendaTerlambat == 0) return;
    try {
      if (tanggalBatasController.text.isNotEmpty && tanggalDikembalikanController.text.isNotEmpty) {
        DateTime batas = _df.parse(tanggalBatasController.text);
        DateTime kembali = _df.parse(tanggalDikembalikanController.text);
        int selisih = kembali.difference(batas).inDays;

        setState(() {
          if (selisih > 0) {
            dendaTerlambatController.text = selisih.toString();
            hasilHitungDendaTerlambat = selisih * tarifDendaTerlambat;
          } else {
            dendaTerlambatController.text = '0';
            hasilHitungDendaTerlambat = 0;
          }
          _updateTotalKeseluruhan();
        });
      }
    } catch (e) {
      debugPrint("Format tanggal salah");
    }
  }

  void _updateTotalKeseluruhan() {
    int tarifKerusakan = dendaKerusakanTerpilih?['tarif']?.toInt() ?? 0;
    setState(() {
      totalDendaKeseluruhan = hasilHitungDendaTerlambat + tarifKerusakan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CardPopup(
      
      title: isEdit ? 'Edit Peminjaman' : 'Tambah Peminjaman',
      width: 400, 
      height: isEdit ? 650 : 500,
      submitText: isEdit ? 'Update' : 'Simpan',
      onCancel: () => Navigator.pop(context),
      onSubmit: _handleSubmit,
      content: SingleChildScrollView(
        child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Nama Peminjam'),
              _textField(double.infinity, namaController),

              const SizedBox(height: 14),
              _label('Alat'),
              _textField(double.infinity, alatController),

              const SizedBox(height: 16),
              Row(
  children: [
    Expanded(
      child: _dateField('Tgl Pinjam', tanggalPinjamController),
    ),
    const SizedBox(width: 16),
    Expanded(
      child: _dateField('Tgl Batas', tanggalBatasController),
    ),
  ],
),

              if (statusValue == PeminjamanStatus.dikembalikan || statusValue == PeminjamanStatus.selesai) ...[
                const SizedBox(height: 16),
                _label('Tanggal Dikembalikan'),
                _textField(double.infinity, tanggalDikembalikanController, 
                  onChanged: (v) => _hitungDendaOtomatis()),
              ],

              if (isEdit) ...[
                const SizedBox(height: 16),
                _label('Status Peminjaman'),
                _statusDropdown(),
              ],

              
              if (statusValue == PeminjamanStatus.selesai) ...[
                const SizedBox(height: 20),
                const Divider(thickness: 1.5),
                const Text("PENALTY & DENDA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 10),

                //Denda Terlambat 
                _cardDenda(
                  label: "Denda Terlambat (Sistem)",
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${dendaTerlambatController.text} Hari x Rp $tarifDendaTerlambat"),
                      Text("Rp $hasilHitungDendaTerlambat", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                //Denda Kerusakan 
                _cardDenda(
                  label: "Denda Kerusakan Barang (Pilih)",
                  content: DropdownButtonHideUnderline(
                    child: DropdownButton<Map<String, dynamic>>(
                      isDense: true,
                      isExpanded: true,
                      value: dendaKerusakanTerpilih,
                      hint: const Text("Pilih Kerusakan", style: TextStyle(fontSize: 12)),
                      items: listDendaKerusakan.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text("${item['jenis_denda']} (Rp ${item['tarif']})", style: const TextStyle(fontSize: 12)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          dendaKerusakanTerpilih = val;
                          _updateTotalKeseluruhan();
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                //TOTAL AKHIR
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.red.shade700, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("TOTAL TAGIHAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text("Rp $totalDendaKeseluruhan", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      ),
    );
  }

  // HELPER

  Widget _cardDenda({required String label, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey)),
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

  Widget _statusDropdown() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: statusValue.label),
        onTap: _nextStatus,
        decoration: InputDecoration(
          suffixIcon: const Icon(Icons.arrow_drop_down),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  void _nextStatus() {
    setState(() {
      if (statusValue == PeminjamanStatus.dipinjam) {
        statusValue = PeminjamanStatus.dikembalikan;
      } else if (statusValue == PeminjamanStatus.dikembalikan) {
        statusValue = PeminjamanStatus.selesai;
      }
      _hitungDendaOtomatis();
    });
  }

  void _handleSubmit() {
     Navigator.pop(context);
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _textField(double width, TextEditingController controller, {Function(String)? onChanged}) {
    return SizedBox(
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
  }

 Widget _dateField(String label, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label(label),
      _textField(double.infinity, controller, onChanged: (v) => _hitungDendaOtomatis()),
    ],
  );
}
}