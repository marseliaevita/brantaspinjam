import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brantaspinjam/services/user_service.dart';
import 'package:brantaspinjam/services/alat_service.dart';
import 'package:brantaspinjam/services/denda_service.dart';
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

  int tarifDendaTerlambat = 0;
  int hasilHitungDendaTerlambat = 0;
  int totalDendaKeseluruhan = 0;

  List<Map<String, dynamic>> usersList = [];
  List<Map<String, dynamic>> alatList = [];
  List<Map<String, dynamic>> listDendaKerusakan = [];
  Map<String, dynamic>? dendaKerusakanTerpilih;

  String? selectedUserId;
  int? selectedAlatId;

  PeminjamanStatus statusValue = PeminjamanStatus.pengajuan;
  bool get isEdit => widget.data != null;
  final DateFormat _df = DateFormat('dd/MM/yyyy');

  @override
void initState() {
  super.initState();
  final data = widget.data;

  //CONTROLLER
  namaController = TextEditingController();
  alatController = TextEditingController();
  tanggalPinjamController = TextEditingController();
  tanggalBatasController = TextEditingController();
  tanggalDikembalikanController = TextEditingController();
  kondisiController = TextEditingController();
  dendaTerlambatController = TextEditingController(text: '0');

  // load data 
  _loadDropdownData();
  _fetchSemuaDataDenda();

  // MODE EDIT
  if (data != null) {
    selectedUserId = data.userId;
    selectedAlatId = data.idAlat;
    statusValue = data.status;

    namaController.text = data.nama;
    alatController.text = data.alat;
    tanggalPinjamController.text = _df.format(data.tanggalPinjam);
    tanggalBatasController.text = _df.format(data.tanggalBatas);

    if (data.tanggalDikembalikan != null) {
      tanggalDikembalikanController.text =
          _df.format(data.tanggalDikembalikan!);
    }

    kondisiController.text = data.kondisi ?? '';
    dendaTerlambatController.text =
        data.dendaTerlambatHari.toString();
  }
}


  // FUNGSI LOGIC

  Future<void> _loadDropdownData() async {
    try {
      final userService = UserService();
      final alatService = AlatService(Supabase.instance.client);

      final allUsers = await userService.getAllUsers();
      final peminjamOnly = allUsers
          .where((u) => u['role'] == 'peminjam')
          .toList();

      final allAlat = await alatService.getAlat();

      setState(() {
        usersList = peminjamOnly;
        alatList = allAlat;
      });
    } catch (e) {
      debugPrint('Gagal load dropdown: $e');
    }
  }

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

        listDendaKerusakan = allDenda
            .where(
              (e) => e['jenis_denda'].toString().toLowerCase() != 'terlambat',
            )
            .toList();
      });
      _hitungDendaOtomatis();
    } catch (e) {
      debugPrint("Gagal ambil denda: $e");
    }
  }

  void _hitungDendaOtomatis() {
    if (tarifDendaTerlambat == 0) return;
    try {
      if (tanggalBatasController.text.isNotEmpty &&
          tanggalDikembalikanController.text.isNotEmpty) {
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
                _dropdownField<String>(
                  label: 'Nama Peminjam',
                  value: selectedUserId,
                  items: usersList
                      .map((u) => {'id': u['user_id'], 'name': u['name']})
                      .toList(),
                  itemLabelKey: 'name',
                  onChanged: (val) => setState(() => selectedUserId = val),
                ),

                const SizedBox(height: 14),
                _dropdownField<int>(
                  label: 'Alat',
                  value: selectedAlatId,
                  items: alatList
                      .map((a) => {'id': a['id_alat'], 'name': a['nama_alat']})
                      .toList(),
                  itemLabelKey: 'name',
                  onChanged: (val) => setState(() => selectedAlatId = val),
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _datePickerField(
                        'Tgl Pinjam',
                        tanggalPinjamController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _datePickerField(
                        'Tgl Batas',
                        tanggalBatasController,
                      ),
                    ),
                  ],
                ),

                if (statusValue == PeminjamanStatus.dikembalikan ||
                    statusValue == PeminjamanStatus.selesai) ...[
                  const SizedBox(height: 16),
                  _datePickerField(
                    'Tgl Dikembalikan',
                    tanggalDikembalikanController,
                  ),
                ],

                if (isEdit) ...[
                  const SizedBox(height: 16),
                  _dropdownField<PeminjamanStatus>(
                    label: 'Status Peminjaman',
                    value: statusValue,
                    items: PeminjamanStatus.values
                        .map((s) => {'id': s, 'name': s.label})
                        .toList(),
                    itemLabelKey: 'name',
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          statusValue = val;
                          _hitungDendaOtomatis();
                        });
                      }
                    },
                  ),
                ],

                if (statusValue == PeminjamanStatus.selesai) ...[
                  const SizedBox(height: 16),
                  _label('Kondisi Alat'),
                  _textField(
                    double.infinity,
                    kondisiController,
                    onChanged: (v) {},
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1.5),
                  const Text(
                    "PENALTY & DENDA",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 10),

                  //Denda Terlambat
                  _cardDenda(
                    label: "Denda Terlambat (Sistem)",
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${dendaTerlambatController.text} Hari x Rp $tarifDendaTerlambat",
                        ),
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

                  //Denda Kerusakan
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
                            child: Text(
                              "${item['jenis_denda']} (Rp ${item['tarif']})",
                              style: const TextStyle(fontSize: 12),
                            ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // HELPER

  Widget _dropdownField<T>({
    required String label,
    required T? value,
    required List<Map<String, dynamic>> items,
    required String itemLabelKey,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        DropdownButtonFormField<T>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
          ),
          hint: Text("Pilih $label"),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item['id'], 
              child: Text(item[itemLabelKey].toString()),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _cardDenda({required String label, required Widget content}) {
    return Column(
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

  void _handleSubmit() {
    Navigator.pop(context);
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _textField(
    double width,
    TextEditingController controller, {
    Function(String)? onChanged,
  }) {
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

  Widget _datePickerField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        SizedBox(
          height: 38,
          child: TextField(
            controller: controller,
            readOnly: true,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: controller.text.isNotEmpty
                    ? _df.parse(controller.text)
                    : DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );

              if (picked != null) {
                setState(() {
                  controller.text = _df.format(picked);
                  _hitungDendaOtomatis();
                });
              }
            },
            style: const TextStyle(fontSize: 12),
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.calendar_today, size: 16),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
