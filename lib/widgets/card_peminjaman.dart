import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:brantaspinjam/services/peminjaman_services.dart';
import 'package:brantaspinjam/services/petugas_services.dart';
import 'package:brantaspinjam/shared/enums.dart';
import 'package:brantaspinjam/shared/colors.dart';
import 'package:brantaspinjam/shared/status_badge.dart';
import 'package:brantaspinjam/model/model_peminjaman.dart';
import 'package:brantaspinjam/screen/admin/peminjaman/penimjaman_add_edit.dart';
import 'package:brantaspinjam/screen/peminjam/popup_kembali.dart';
import 'package:brantaspinjam/screen/petugas/popup_cek.dart';
import 'package:brantaspinjam/widgets/card_popup.dart';

class PeminjamanCard extends StatefulWidget {
  final CardMode mode;
  final PeminjamanModel data;
  final VoidCallback? onRefresh;
  final Future<void> Function()? onDelete;

  const PeminjamanCard({
    super.key,
    required this.mode,
    required this.data,
    this.onRefresh,
    this.onDelete,
  });

  @override
  State<PeminjamanCard> createState() => _PeminjamanCardState();
}

class _PeminjamanCardState extends State<PeminjamanCard> {
  bool isExpanded = false;

  String get headerTitle {
    if (widget.mode == CardMode.peminjam) {
      return widget.data.alat;
    }
    return widget.data.nama;
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () => setState(() => isExpanded = !isExpanded),
        child: Stack(
          children: [
            // CARD UTAMA
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.strokeCard),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    children: [
                      if (widget.mode != CardMode.peminjam) ...[
                        const Icon(
                          Icons.person,
                          size: 22,
                          color: AppColors.greyText,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          headerTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 25,
                        color: AppColors.strokeCard,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// STATUS TEXT
                  Text(
                    data.status.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: data.status.color,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// TANGGAL + BADGE
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 15,
                        color: data.status.color,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatDate(data.tanggalPinjam),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.greyText,
                        ),
                      ),
                      const Spacer(),
                      Transform.translate(
                        offset: const Offset(0, -4),
                        child: StatusBadge(status: data.status),
                      ),
                    ],
                  ),

                  /// EXPANDED CONTENT
                  if (isExpanded) ..._buildExpandedContent(context),
                ],
              ),
            ),

            /// SHADOW
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.05),
                        Colors.transparent,
                        Colors.white.withOpacity(0.25),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // EXPANDED CONTENT
  List<Widget> _buildExpandedContent(BuildContext context) {
    final data = widget.data;
    final List<Widget> content = [];

    content.add(const Divider(height: 20));

    /// NAMA ALAT
    if (widget.mode != CardMode.peminjam) {
      content.add(
        Text(
          data.alat,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      );
    }

    content.add(const SizedBox(height: 12));

    /// TANGGAL
    content.add(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: _buildDateColumn(
              "Tanggal Pinjam",
              _formatDate(data.tanggalPinjam),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: _buildDateColumn(
              "Batas Pinjam",
              _formatDate(data.tanggalBatas),
            ),
          ),
          if (data.showTanggalDikembalikan &&
              data.tanggalDikembalikan != null) ...[
            const SizedBox(width: 16),
            Flexible(
              child: _buildDateColumn(
                "Tanggal Dikembalikan",
                _formatDate(data.tanggalDikembalikan!),
              ),
            ),
          ],
        ],
      ),
    );


    /// BUTTON PER ROLE
    content.add(const SizedBox(height: 12));
    content.addAll(_buildActionButtons(context));

    return content;
  }

  // ACTION BUTTON
  List<Widget> _buildActionButtons(BuildContext context) {
    final data = widget.data;
    final List<Widget> widgets = [];

    if (widget.mode == CardMode.admin) {
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _iconButton(
              icon: Icons.edit,
              onTap: () async {
                final refresh = await showDialog<bool>(
                  context: context,
                  builder: (_) => PeminjamanAddEdit(data: data),
                );

                if (refresh == true) {
                  widget.onRefresh?.call();
                }
              },
            ),
            const SizedBox(width: 8),

            _iconButton(
              icon: Icons.delete_outline,
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (_) => ConfirmActionPopup(
                    title: "Hapus Peminjaman",
                    message: "Anda yakin menghapus data peminjaman ini?",
                    confirmText: "Hapus",
                    onConfirm: () {
                      Navigator.pop(context, true);
                    },
                  ),
                );

                if (confirmed != true) return;
                if (widget.data.idPeminjaman == null) return;

                await deletePeminjaman(widget.data.idPeminjaman!);

                widget.onRefresh?.call();
              },
            ),
          ],
        ),
      );
    }

    if (widget.mode == CardMode.petugas) {
      widgets.add(const SizedBox(height: 12));

      if (data.isPengajuan) {
        // tombol Disetujui / Ditolak
        widgets.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 112,
                height: 42,
                child: ElevatedButton(
                  onPressed: () async {
                    final success = await approvePeminjaman(data.idPeminjaman!);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Peminjaman disetujui')),
                      );
                      widget.onRefresh?.call();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E0A26),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Disetujui",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 112,
                height: 42,
                child: ElevatedButton(
                  onPressed: () async {
                    final success = await rejectPeminjaman(data.idPeminjaman!);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Peminjaman ditolak')),
                      );
                      widget.onRefresh?.call();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF0000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Ditolak",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (data.isDikembalikan) {
        // tombol Check
        widgets.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 66,
                height: 29,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => PeminjamanCekPopup(
                        data: data,
                        onRefresh: widget.onRefresh,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.red, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.zero,
                    elevation: 0,
                  ),
                  child: const Text(
                    "Cek",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }

    if (widget.mode == CardMode.peminjam && data.isDipinjam) {
      widgets.add(const SizedBox(height: 12));

      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 198,
              height: 42,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => PengembalianPopup(
                  data: data,
                  onRefresh: widget.onRefresh,
                ),
              );
            },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1155A2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Ajukan Pengembalian",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return widgets;
  }

  // SMALL WIDGETS
  Widget _buildDateColumn(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.dipinjam,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.calendar_month, size: 15),
            const SizedBox(width: 4),
            Text(
              date,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.greyText,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRowValue(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(value, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.strokeCard.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 15, color: AppColors.strokeCard),
      ),
    );
  }

  Widget _primaryButton(String text, {required VoidCallback onPressed}) {
    return SizedBox(
      width: 140,
      height: 42,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.dipinjam,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _dangerButton(String text, {required VoidCallback onPressed}) {
    return SizedBox(
      width: 112,
      height: 42,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
